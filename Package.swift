// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ImageSliderCompareView",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ImageSliderCompareView",
            targets: ["ImageSliderCompareView"]),
    ],
    dependencies: [
                .package(url: "https://github.com/lorenzofiamingo/swiftui-cached-async-image.git",
                        .upToNextMajor(from: "2.1.1")),
                
            ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ImageSliderCompareView"),

    ]
)
