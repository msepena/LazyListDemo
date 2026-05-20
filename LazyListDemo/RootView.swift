import SwiftUI
import PhotoModels
import PhotosFeature
import PhotoDetailFeature

struct RootView: View {
    @State private var coordinator = AppCoordinator()

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            PhotosListView()
                .navigationDestination(for: Photo.self) { photo in
                    PhotoDetailView(photo: photo)
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
