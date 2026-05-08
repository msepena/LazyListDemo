// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "ImageUI",
    platforms: [.iOS("26.4")],
    products: [
        .library(name: "ImageUI", targets: ["ImageUI"])
    ],
    dependencies: [
        .package(path: "../PhotosNetworking")
    ],
    targets: [
        .target(
            name: "ImageUI",
            dependencies: [
                .product(name: "PhotosNetworking", package: "PhotosNetworking")
            ],
            swiftSettings: [
                .defaultIsolation(MainActor.self)
            ]
        ),
        .testTarget(
            name: "ImageUITests",
            dependencies: ["ImageUI"]
        )
    ],
    swiftLanguageModes: [.v6]
)
