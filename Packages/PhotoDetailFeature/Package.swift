// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "PhotoDetailFeature",
    defaultLocalization: "en",
    platforms: [.iOS("26.4")],
    products: [
        .library(name: "PhotoDetailFeature", targets: ["PhotoDetailFeature"])
    ],
    dependencies: [
        .package(path: "../PhotoModels"),
        .package(path: "../ImageUI")
    ],
    targets: [
        .target(
            name: "PhotoDetailFeature",
            dependencies: [
                .product(name: "PhotoModels", package: "PhotoModels"),
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
            name: "PhotoDetailFeatureTests",
            dependencies: ["PhotoDetailFeature"]
        )
    ],
    swiftLanguageModes: [.v6]
)
