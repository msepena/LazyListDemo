import Foundation

public struct Photo: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public let author: String
    public let width: Int
    public let height: Int
    public let url: String
    public let downloadURL: String

    public init(
        id: String,
        author: String,
        width: Int,
        height: Int,
        url: String,
        downloadURL: String
    ) {
        self.id = id
        self.author = author
        self.width = width
        self.height = height
        self.url = url
        self.downloadURL = downloadURL
    }

    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURL = "download_url"
    }

    public func thumbnailURL(size: Int = 200) -> URL {
        // Picsum ids from /v2/list are numeric strings, so this always parses.
        URL(string: "https://picsum.photos/id/\(id)/\(size)/\(size)")!
    }

    public func detailURL(maxDimension: Int = 1600) -> URL {
        let longestSide = max(width, height, 1)
        let scale = longestSide > maxDimension ? Double(maxDimension) / Double(longestSide) : 1
        let scaledWidth = max(1, Int((Double(width) * scale).rounded()))
        let scaledHeight = max(1, Int((Double(height) * scale).rounded()))
        // Picsum ids from /v2/list are numeric strings, so this always parses.
        return URL(string: "https://picsum.photos/id/\(id)/\(scaledWidth)/\(scaledHeight)")!
    }
}
