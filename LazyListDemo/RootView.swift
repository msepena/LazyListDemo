import SwiftUI
import PhotosFeature
import PhotoDetailFeature

struct RootView: View {
    @State private var coordinator = AppCoordinator()

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            PhotosListView { photo in
                coordinator.showPhotoDetail(photo)
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .photoDetail(let photo):
                    PhotoDetailView(photo: photo)
                }
            }
        }
    }
}

#Preview {
    RootView()
}
