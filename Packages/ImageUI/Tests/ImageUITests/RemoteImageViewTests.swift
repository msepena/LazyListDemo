import Testing
import Foundation
@testable import ImageUI

@MainActor
struct RemoteImageViewTests {
    @Test func initializesWithNilURL() {
        let view = RemoteImageView(url: nil)
        #expect(view.url == nil)
    }

    @Test func initializesWithURL() {
        let url = URL(string: "https://example.com/img.jpg")
        let view = RemoteImageView(url: url)
        #expect(view.url == url)
    }
}
