import Observation
import PhotoModels

enum AppRoute: Hashable {
    case photoDetail(Photo)
}

@Observable
final class AppCoordinator {
    var path: [AppRoute] = []

    func showPhotoDetail(_ photo: Photo) {
        path.append(.photoDetail(photo))
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }
}
