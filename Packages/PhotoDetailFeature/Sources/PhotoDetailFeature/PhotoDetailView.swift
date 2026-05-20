import SwiftUI
import PhotoModels
import ImageUI

public struct PhotoDetailView: View {
    public let photo: Photo

    @ScaledMetric(relativeTo: .body) private var maxImageHeight: CGFloat = 480

    public init(photo: Photo) {
        self.photo = photo
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                RemoteImageView(
                    url: photo.detailURL(maxDimension: 1600),
                    contentMode: .fit,
                    accessibilityLabel: Text("Photo by \(photo.author)")
                )
                .aspectRatio(
                    CGFloat(photo.width) / CGFloat(photo.height),
                    contentMode: .fit
                )
                .frame(maxHeight: maxImageHeight)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 8) {
                    Text(photo.author)
                        .font(.title2.weight(.semibold))
                    Text("\(photo.width) × \(photo.height)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .accessibilityLabel("\(photo.width) by \(photo.height) pixels")
                    Link(destination: photo.url) {
                        Label("View on Picsum", systemImage: "arrow.up.right.square")
                    }
                    .accessibilityHint("Opens in your browser")
                }
                .frame(maxWidth: 680, alignment: .leading)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle(photo.author)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: photo.url)
            }
        }
    }
}
