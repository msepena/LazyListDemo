import Testing
import Foundation
import PhotoModels
@testable import LazyListDemo

@MainActor
struct AppCoordinatorTests {
    private static let stubPhoto = Photo(
        id: "1",
        author: "Test",
        width: 100,
        height: 100,
        url: URL(string: "https://example.com")!,
        downloadURL: URL(string: "https://example.com/full")!
    )

    @Test func startsWithEmptyPath() {
        let coordinator = AppCoordinator()
        #expect(coordinator.path.isEmpty)
    }

    @Test func showPhotoDetailAppendsRoute() {
        let coordinator = AppCoordinator()
        coordinator.showPhotoDetail(Self.stubPhoto)
        #expect(coordinator.path == [.photoDetail(Self.stubPhoto)])
    }

    @Test func popRemovesLast() {
        let coordinator = AppCoordinator()
        coordinator.showPhotoDetail(Self.stubPhoto)
        coordinator.pop()
        #expect(coordinator.path.isEmpty)
    }

    @Test func popOnEmptyIsNoop() {
        let coordinator = AppCoordinator()
        coordinator.pop()
        #expect(coordinator.path.isEmpty)
    }

    @Test func popToRootClearsPath() {
        let coordinator = AppCoordinator()
        coordinator.showPhotoDetail(Self.stubPhoto)
        coordinator.showPhotoDetail(Self.stubPhoto)
        coordinator.popToRoot()
        #expect(coordinator.path.isEmpty)
    }
}
