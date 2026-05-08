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
        case failed(String)
    }

    public var state: LoadState = .idle
    private let service: PhotoService

    public init(service: PhotoService = .init()) {
        self.service = service
    }

    public func load() async {
        state = .loading
        do {
            let photos = try await service.fetchPhotos()
            state = .loaded(photos)

            let warmupURLs = photos.prefix(12).compactMap { $0.thumbnailURL() }
            Task { await ImageLoader.shared.prefetch(Array(warmupURLs)) }
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
