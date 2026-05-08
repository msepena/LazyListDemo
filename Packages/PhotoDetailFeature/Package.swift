// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "PhotoDetailFeature",
    platforms: [.iOS("26.4")],
    products: [
        .library(name: "PhotoDetailFeature", targets: ["PhotoDetailFeature"])
    ],
    dependencies: [
        .package(path: "../PhotoModels"),
        .package(path: "../PhotosFeature")
    ],
    targets: [
        .target(
            name: "PhotoDetailFeature",
            dependencies: [
                .product(name: "PhotoModels", package: "PhotoModels"),
                .product(name: "PhotosFeature", package: "PhotosFeature")
            ],
            swiftSettings: [
                .defaultIsolation(MainActor.self)
            ]
        ),
        .testTarget(
            name: "PhotoDetailFeatureTests",
            dependencies: ["PhotoDetailFeature"]
        )
    ],
    swiftLanguageModes: [.v6]
)
