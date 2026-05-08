// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "PhotoModels",
    platforms: [.iOS("26.4")],
    products: [
        .library(name: "PhotoModels", targets: ["PhotoModels"])
    ],
    targets: [
        .target(name: "PhotoModels"),
        .testTarget(name: "PhotoModelsTests", dependencies: ["PhotoModels"])
    ],
    swiftLanguageModes: [.v6]
)
