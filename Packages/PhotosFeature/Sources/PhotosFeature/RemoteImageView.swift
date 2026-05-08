import SwiftUI
import PhotosNetworking

public struct RemoteImageView: View {
    public let url: URL?

    @State private var image: UIImage?

    public init(url: URL?) {
        self.url = url
    }

    public var body: some View {
        ZStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Color.gray.opacity(0.15)
                ProgressView()
            }
        }
        .task(id: url) {
            guard let url else { return }
            image = nil
            image = try? await ImageLoader.shared.image(for: url)
        }
    }
}
