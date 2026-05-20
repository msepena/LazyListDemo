import SwiftUI
import PhotoModels
import ImageUI

public struct PhotoDetailView: View {
    public let photo: Photo

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
                .clipShape(RoundedRectangle(cornerRadius: 12))
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
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle(photo.author)
        .navigationBarTitleDisplayMode(.inline)
    }
}
