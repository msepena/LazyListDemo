import SwiftUI
import Foundation
import PhotoModels

/// The photo feed: a scrolling list with loading, error, and loaded states.
public struct PhotosListView: View {
    @State private var viewModel: PhotosViewModel

    public init(viewModel: PhotosViewModel = PhotosViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        content
            .navigationTitle(Text("Photos", bundle: .module))
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
            ProgressView {
                Text("Loading photos…", bundle: .module)
            }
        case .loaded(let photos):
            List(photos) { photo in
                NavigationLink(value: photo) {
                    PhotoRow(photo: photo)
                }
                .onAppear { viewModel.prefetchAhead(of: photo) }
            }
            .refreshable { await viewModel.load() }
        case .failed(let error):
            ContentUnavailableView {
                Label {
                    Text("Couldn't load photos", bundle: .module)
                } icon: {
                    Image(systemName: errorIcon(for: error))
                }
            } description: {
                Text(error.localizedDescription)
            } actions: {
                Button {
                    Task { await viewModel.load() }
                } label: {
                    Text("Retry", bundle: .module)
                }
            }
        }
    }

    private func errorIcon(for error: Error) -> String {
        if let urlError = error as? URLError,
           urlError.code == .notConnectedToInternet || urlError.code == .networkConnectionLost {
            return "wifi.slash"
        }
        return "exclamationmark.triangle"
    }
}

#Preview {
    let viewModel = PhotosViewModel()
    viewModel.state = .loaded([
        Photo(
            id: "10",
            author: "Paul Jarvis",
            width: 2500,
            height: 1667,
            url: URL(string: "https://picsum.photos/id/10")!,
            downloadURL: URL(string: "https://picsum.photos/id/10/2500/1667")!
        ),
        Photo(
            id: "20",
            author: "Aleks Dorohovich",
            width: 3670,
            height: 2462,
            url: URL(string: "https://picsum.photos/id/20")!,
            downloadURL: URL(string: "https://picsum.photos/id/20/3670/2462")!
        ),
        Photo(
            id: "30",
            author: "Vadim Sherbakov",
            width: 1280,
            height: 901,
            url: URL(string: "https://picsum.photos/id/30")!,
            downloadURL: URL(string: "https://picsum.photos/id/30/1280/901")!
        )
    ])
    return NavigationStack {
        PhotosListView(viewModel: viewModel)
    }
}

