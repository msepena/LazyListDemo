// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "PhotosFeature",
    defaultLocalization: "en",
    platforms: [.iOS("26.4")],
    products: [
        .library(name: "PhotosFeature", targets: ["PhotosFeature"])
    ],
    dependencies: [
        .package(path: "../PhotoModels"),
        .package(path: "../PhotosNetworking"),
        .package(path: "../ImageUI")
    ],
    targets: [
        .target(
            name: "PhotosFeature",
            dependencies: [
                .product(name: "PhotoModels", package: "PhotoModels"),
                .product(name: "PhotosNetworking", package: "PhotosNetworking"),
                .product(name: "ImageUI", package: "ImageUI")
            ],
            resources: [
                .process("Localizable.xcstrings")
            ],
            swiftSettings: [
                .defaultIsolation(MainActor.self)
            ]
        ),
        .testTarget(
            name: "PhotosFeatureTests",
            dependencies: [
                "PhotosFeature",
                .product(name: "PhotosNetworking", package: "PhotosNetworking")
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)
