import SwiftUI

public struct PhotosListView: View {
    @State private var viewModel = PhotosViewModel()

    public init() {}

    public var body: some View {
        NavigationStack {
            content
                .navigationTitle("Photos")
        }
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
            ProgressView()
        case .loaded(let photos):
            List(photos) { PhotoRow(photo: $0) }
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
