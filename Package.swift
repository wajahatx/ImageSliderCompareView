// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


let package = Package(
    name: "ImageSliderCompareView",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "ImageSliderCompareView",
            targets: ["ImageSliderCompareView"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/lorenzofiamingo/swiftui-cached-async-image.git",
            .upToNextMajor(from: "2.1.1")
        ),
    ],
    targets: [
        .target(
            name: "ImageSliderCompareView",
            dependencies: [
                .product(name: "CachedAsyncImage", package: "swiftui-cached-async-image")
            ]
        ),
    ]
)
