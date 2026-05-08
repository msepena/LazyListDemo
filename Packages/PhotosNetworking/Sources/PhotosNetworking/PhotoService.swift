import Foundation
import PhotoModels

public struct PhotoService: Sendable {
    public let session: URLSession
    public let endpoint: URL

    public init(
        session: URLSession = .shared,
        endpoint: URL = URL(string: "https://picsum.photos/v2/list")!
    ) {
        self.session = session
        self.endpoint = endpoint
    }

    @concurrent
    public func fetchPhotos() async throws -> [Photo] {
        let (data, _) = try await session.data(from: endpoint)
        return try JSONDecoder().decode([Photo].self, from: data)
    }
}
