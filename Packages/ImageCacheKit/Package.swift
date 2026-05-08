// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "ImageCacheKit",
    platforms: [.iOS("26.4")],
    products: [
        .library(name: "ImageCacheKit", targets: ["ImageCacheKit"])
    ],
    targets: [
        .target(name: "ImageCacheKit"),
        .testTarget(name: "ImageCacheKitTests", dependencies: ["ImageCacheKit"])
    ],
    swiftLanguageModes: [.v6]
)
