import SwiftUI
import PhotoModels

public struct PhotoRow: View {
    public let photo: Photo

    public init(photo: Photo) {
        self.photo = photo
    }

    public var body: some View {
        HStack(spacing: 12) {
            RemoteImageView(url: photo.thumbnailURL())
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(photo.author)
                    .font(.headline)
                    .lineLimit(1)
                Text("\(photo.width)×\(photo.height)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
