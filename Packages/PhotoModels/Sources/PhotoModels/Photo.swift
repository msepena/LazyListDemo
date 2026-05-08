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

    public func thumbnailURL(size: Int = 200) -> URL? {
        URL(string: "https://picsum.photos/id/\(id)/\(size)/\(size)")
    }
}
