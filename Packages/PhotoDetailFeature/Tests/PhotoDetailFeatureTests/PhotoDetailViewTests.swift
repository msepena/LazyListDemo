import Testing
import PhotoModels
@testable import PhotoDetailFeature

@MainActor
struct PhotoDetailViewTests {
    @Test func initializesWithPhoto() {
        let photo = Photo(
            id: "1",
            author: "Test",
            width: 100,
            height: 100,
            url: "https://example.com",
            downloadURL: "https://example.com/full"
        )
        let view = PhotoDetailView(photo: photo)
        #expect(view.photo == photo)
    }
}
