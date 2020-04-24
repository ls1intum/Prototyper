// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Prototyper",
    platforms: [
        .iOS(.v13)
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
