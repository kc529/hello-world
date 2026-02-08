// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "IronLog",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "IronLog", targets: ["IronLog"])
    ],
    targets: [
        .target(
            name: "IronLog",
            path: "Sources/IronLog"
        ),
        .testTarget(
            name: "IronLogTests",
            dependencies: ["IronLog"],
            path: "Tests/IronLogTests"
        )
    ]
)
