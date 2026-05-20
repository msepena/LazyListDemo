import SwiftUI
import PhotoModels
import ImageUI

public struct PhotoRow: View {
    public let photo: Photo

    @ScaledMetric(relativeTo: .body) private var thumbnailSize: CGFloat = 60
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    public init(photo: Photo) {
        self.photo = photo
    }

    public var body: some View {
        HStack(spacing: 12) {
            RemoteImageView(url: photo.thumbnailURL())
                .frame(width: thumbnailSize, height: thumbnailSize)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(photo.author)
                    .font(.headline)
                    .lineLimit(dynamicTypeSize.isAccessibilitySize ? 2 : 1)
                Text("\(photo.width)×\(photo.height)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("Photo by \(photo.author), \(photo.width) by \(photo.height) pixels", bundle: .module))
        .accessibilityHint(Text("Shows the full photo", bundle: .module))
    }
}
