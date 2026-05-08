// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "PhotosFeature",
    platforms: [.iOS("26.4")],
    products: [
        .library(name: "PhotosFeature", targets: ["PhotosFeature"])
    ],
    dependencies: [
        .package(path: "../PhotoModels"),
        .package(path: "../PhotosNetworking")
    ],
    targets: [
        .target(
            name: "PhotosFeature",
            dependencies: [
                .product(name: "PhotoModels", package: "PhotoModels"),
                .product(name: "PhotosNetworking", package: "PhotosNetworking")
            ],
            swiftSettings: [
                .defaultIsolation(MainActor.self)
            ]
        ),
        .testTarget(
            name: "PhotosFeatureTests",
            dependencies: ["PhotosFeature"]
        )
    ],
    swiftLanguageModes: [.v6]
)
