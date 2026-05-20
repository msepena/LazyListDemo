import Testing
import Foundation
@testable import PhotoModels

@Test func photoDecodesFromJSON() throws {
    let json = """
    {
        "id": "0",
        "author": "Alejandro Escamilla",
        "width": 5616,
        "height": 3744,
        "url": "https://unsplash.com/photos/yC-Yzbqy7PY",
        "download_url": "https://picsum.photos/id/0/5616/3744"
    }
    """.data(using: .utf8)!

    let photo = try JSONDecoder().decode(Photo.self, from: json)
    #expect(photo.id == "0")
    #expect(photo.author == "Alejandro Escamilla")
    #expect(photo.downloadURL == "https://picsum.photos/id/0/5616/3744")
}

@Test func thumbnailURLFormatsCorrectly() {
    let photo = Photo(
        id: "42",
        author: "x",
        width: 100,
        height: 100,
        url: "https://example.com",
        downloadURL: "https://example.com"
    )
    #expect(photo.thumbnailURL(size: 150).absoluteString == "https://picsum.photos/id/42/150/150")
}

@Test func detailURLPreservesLandscapeAspectRatio() {
    let photo = Photo(
        id: "7",
        author: "x",
        width: 4000,
        height: 3000,
        url: "u",
        downloadURL: "u"
    )
    #expect(photo.detailURL(maxDimension: 1600).absoluteString == "https://picsum.photos/id/7/1600/1200")
}

@Test func detailURLPreservesPortraitAspectRatio() {
    let photo = Photo(
        id: "7",
        author: "x",
        width: 3000,
        height: 4000,
        url: "u",
        downloadURL: "u"
    )
    #expect(photo.detailURL(maxDimension: 1600).absoluteString == "https://picsum.photos/id/7/1200/1600")
}

@Test func detailURLKeepsDimensionsWhenSmallerThanMax() {
    let photo = Photo(
        id: "7",
        author: "x",
        width: 800,
        height: 600,
        url: "u",
        downloadURL: "u"
    )
    #expect(photo.detailURL(maxDimension: 1600).absoluteString == "https://picsum.photos/id/7/800/600")
}
