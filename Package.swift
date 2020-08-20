// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Prototyper",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "Prototyper", targets: ["Prototyper"])
    ],
    targets: [
        .target(name: "Prototyper"),
        .testTarget(name: "PrototyperTests",
                    dependencies: [
                        "Prototyper"
                    ])
    ]
)
