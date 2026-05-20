import SwiftUI
import PhotosNetworking

/// A SwiftUI view that asynchronously loads and displays a remote image.
public struct RemoteImageView: View {
    public let url: URL?
    private let contentMode: ContentMode
    private let accessibilityLabel: Text?

    @State private var image: UIImage?

    public init(
        url: URL?,
        contentMode: ContentMode = .fill,
        accessibilityLabel: Text? = nil
    ) {
        self.url = url
        self.contentMode = contentMode
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        ZStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .flipsForRightToLeftLayoutDirection(false)
            } else {
                Color(.secondarySystemFill)
                ProgressView()
                    .tint(.secondary)
            }
        }
        .task(id: url) {
            guard let url else { return }
            image = nil
            image = try? await ImageLoader.shared.image(for: url)
        }
        .accessibilityElement()
        .accessibilityLabel(accessibilityLabel ?? Text(verbatim: ""))
        .accessibilityAddTraits(accessibilityLabel == nil ? [] : .isImage)
        .accessibilityHidden(accessibilityLabel == nil)
    }
}
