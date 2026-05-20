import SwiftUI
import PhotoModels

public struct PhotosListView: View {
    @State private var viewModel = PhotosViewModel()
    let onSelectPhoto: (Photo) -> Void

    public init(onSelectPhoto: @escaping (Photo) -> Void) {
        self.onSelectPhoto = onSelectPhoto
    }

    public var body: some View {
        content
            .navigationTitle("Photos")
            .task {
                if case .idle = viewModel.state {
                    await viewModel.load()
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading photos…")
        case .loaded(let photos):
            List(photos) { photo in
                Button { onSelectPhoto(photo) } label: { PhotoRow(photo: photo) }
                    .buttonStyle(.plain)
            }
            .refreshable { await viewModel.load() }
        case .failed(let message):
            ContentUnavailableView(
                "Couldn't load photos",
                systemImage: "wifi.slash",
                description: Text(message)
            )
        }
    }
}
