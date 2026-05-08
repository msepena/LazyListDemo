import SwiftUI
import PhotoModels

public struct PhotoDetailView: View {
    public let photo: Photo

    public init(photo: Photo) {
        self.photo = photo
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                RemoteImageView(url: photo.thumbnailURL(size: 800))
                    .aspectRatio(
                        CGFloat(photo.width) / CGFloat(photo.height),
                        contentMode: .fit
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 8) {
                    Text(photo.author)
                        .font(.title2.weight(.semibold))
                    Text("\(photo.width) × \(photo.height)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    if let sourceURL = URL(string: photo.url) {
                        Link("View on Picsum", destination: sourceURL)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle(photo.author)
        .navigationBarTitleDisplayMode(.inline)
    }
}
