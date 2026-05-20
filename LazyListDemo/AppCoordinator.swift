import Observation
import SwiftUI
import PhotoModels

enum AppRoute: Hashable {
    case photoDetail(Photo)
}

@Observable
final class AppCoordinator {
    var path = NavigationPath()

    func showPhotoDetail(_ photo: Photo) {
        path.append(AppRoute.photoDetail(photo))
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
