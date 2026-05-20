import SwiftUI
import PhotoModels

public struct PhotosListView: View {
    @State private var viewModel = PhotosViewModel()

    public init() {}

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
                NavigationLink(value: photo) {
                    PhotoRow(photo: photo)
                }
            }
            .refreshable { await viewModel.load() }
        case .failed(let error):
            ContentUnavailableView(
                "Couldn't load photos",
                systemImage: "wifi.slash",
                description: Text(error.localizedDescription)
            )
        }
    }
}
