import Foundation
import PhotoModels

/// Fetches the Picsum photo feed.
public struct PhotoService: Sendable {
    let session: URLSession
    let endpoint: URL

    public init(
        session: URLSession = .shared,
        endpoint: URL = URL(string: "https://picsum.photos/v2/list")!
    ) {
        self.session = session
        self.endpoint = endpoint
    }

    /// Fetches and decodes the current photo feed.
    @concurrent
    public func list() async throws -> [Photo] {
        let (data, _) = try await session.data(from: endpoint)
        try Task.checkCancellation()
        return try JSONDecoder().decode([Photo].self, from: data)
    }
}
