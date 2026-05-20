import UIKit
import ImageCacheKit

/// Loads and caches remote images, de-duplicating in-flight requests.
public actor ImageLoader {
    public static let shared = ImageLoader()

    private let cache: ImageCache
    private var inFlight: [URL: Task<UIImage, Error>] = [:]

    public init(cache: ImageCache = .shared) {
        self.cache = cache
    }

    /// Returns the image at `url`, serving a cached copy when available.
    public func image(for url: URL) async throws -> UIImage {
        if let hit = cache.image(for: url) { return hit }
        if let existing = inFlight[url] { return try await existing.value }

        // Intentionally unstructured: the download finishes and warms the
        // cache even if the calling task is cancelled, so a recycled row that
        // scrolls back into view still gets a cache hit.
        let task = Task {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                throw URLError(.cannotDecodeContentData)
            }
            return image
        }
        inFlight[url] = task
        defer { inFlight[url] = nil }

        let image = try await task.value
        cache.insert(image, for: url)
        return image
    }

    /// Warms the cache for `urls`, keeping at most `maxConcurrent` downloads in flight.
    public func prefetch(_ urls: [URL], maxConcurrent: Int = 6) async {
        await withTaskGroup(of: Void.self) { group in
            var iterator = urls.makeIterator()

            for _ in 0..<maxConcurrent {
                guard let url = iterator.next() else { break }
                group.addTask {
                    _ = try? await self.image(for: url)
                }
            }
            while await group.next() != nil {
                guard let url = iterator.next() else { continue }
                group.addTask {
                    _ = try? await self.image(for: url)
                }
            }
        }
    }
}
