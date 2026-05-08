import Testing
import UIKit
@testable import ImageCacheKit

@Test func roundTripImage() {
    let cache = ImageCache()
    let url = URL(string: "https://example.com/foo.jpg")!
    let image = UIImage(systemName: "star")!

    cache.insert(image, for: url)
    #expect(cache.image(for: url) != nil)

    cache.remove(for: url)
    #expect(cache.image(for: url) == nil)
}

@Test func removeAllClearsCache() {
    let cache = ImageCache()
    let urlA = URL(string: "https://example.com/a.jpg")!
    let urlB = URL(string: "https://example.com/b.jpg")!
    let image = UIImage(systemName: "star")!

    cache.insert(image, for: urlA)
    cache.insert(image, for: urlB)
    cache.removeAll()

    #expect(cache.image(for: urlA) == nil)
    #expect(cache.image(for: urlB) == nil)
}
