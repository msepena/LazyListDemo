import UIKit

public final class ImageCache: @unchecked Sendable {
    public static let shared = ImageCache()

    private let cache = NSCache<NSURL, UIImage>()

    public init(countLimit: Int = 200, totalCostLimit: Int = 64 * 1024 * 1024) {
        cache.countLimit = countLimit
        cache.totalCostLimit = totalCostLimit
    }

    public func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    public func insert(_ image: UIImage, for url: URL) {
        let cost = Int(image.size.width * image.size.height * 4)
        cache.setObject(image, forKey: url as NSURL, cost: cost)
    }

    public func removeImage(for url: URL) {
        cache.removeObject(forKey: url as NSURL)
    }

    public func removeAll() {
        cache.removeAllObjects()
    }
}
