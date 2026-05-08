import Testing
import Foundation
@testable import PhotosNetworking

@Test func serviceConstructsWithDefaults() {
    let service = PhotoService()
    #expect(service.endpoint.absoluteString == "https://picsum.photos/v2/list")
}

@Test func serviceAcceptsCustomEndpoint() {
    let custom = URL(string: "https://example.com/photos")!
    let service = PhotoService(endpoint: custom)
    #expect(service.endpoint == custom)
}
