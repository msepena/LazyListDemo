import Foundation
import Observation
import PhotoModels
import PhotosNetworking

@Observable
public final class PhotosViewModel {
    public enum LoadState {
        case idle
        case loading
        case loaded([Photo])
        case failed(Error)
    }

    public var state: LoadState = .idle
    private let service: PhotoService
    private var prefetchTask: Task<Void, Never>?

    public init(service: PhotoService = .init()) {
        self.service = service
    }

    public func load() async {
        let previousState = state
        if !Task.isCancelled {
            state = .loading
        }
        do {
            let photos = try await service.list()
            state = .loaded(photos)

            let warmupURLs = photos.prefix(12).map { $0.thumbnailURL() }
            prefetchTask?.cancel()
            prefetchTask = Task { await ImageLoader.shared.prefetch(warmupURLs) }
        } catch is CancellationError {
            // Cancellation is control flow, not a failure — restore the prior
            // state so a re-entered .task / .refreshable can retry cleanly.
            state = previousState
        } catch let urlError as URLError where urlError.code == .cancelled {
            // URLSession surfaces task cancellation as URLError(.cancelled).
            state = previousState
        } catch {
            state = .failed(error)
        }
    }
}
