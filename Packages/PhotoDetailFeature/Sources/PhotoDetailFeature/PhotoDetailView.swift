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
                    accessibilityLabel: Text("Photo by \(photo.author)", bundle: .module)
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
                        .accessibilityLabel(Text("\(photo.width) by \(photo.height) pixels", bundle: .module))
                    Link(destination: photo.url) {
                        Label {
                            Text("View on Picsum", bundle: .module)
                        } icon: {
                            Image(systemName: "arrow.up.right.square")
                        }
                    }
                    .accessibilityHint(Text("Opens in your browser", bundle: .module))
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
