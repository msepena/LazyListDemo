import SwiftUI
import Foundation
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
            ContentUnavailableView {
                Label("Couldn't load photos", systemImage: errorIcon(for: error))
            } description: {
                Text(error.localizedDescription)
            } actions: {
                Button("Retry") {
                    Task { await viewModel.load() }
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
