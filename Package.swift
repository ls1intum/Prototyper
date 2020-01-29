// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Prototyper",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "Prototyper",
            targets: ["Prototyper"]),
    ],
    dependencies: [
        .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "18.0.0")
    ],
    targets: [
        .target(
            name: "Prototyper",
            dependencies: ["KeychainSwift"]),
        .testTarget(
            name: "PrototyperTests",
            dependencies: ["Prototyper"]),
    ]
)
