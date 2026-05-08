// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "PhotosNetworking",
    platforms: [.iOS("26.4")],
    products: [
        .library(name: "PhotosNetworking", targets: ["PhotosNetworking"])
    ],
    dependencies: [
        .package(path: "../PhotoModels"),
        .package(path: "../ImageCacheKit")
    ],
    targets: [
        .target(
            name: "PhotosNetworking",
            dependencies: [
                .product(name: "PhotoModels", package: "PhotoModels"),
                .product(name: "ImageCacheKit", package: "ImageCacheKit")
            ]
        ),
        .testTarget(
            name: "PhotosNetworkingTests",
            dependencies: ["PhotosNetworking"]
        )
    ],
    swiftLanguageModes: [.v6]
)
