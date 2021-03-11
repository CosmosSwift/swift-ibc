// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-ibc",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .executable(name: "Transfer", targets: ["Transfer"]

        ),
        .library(name: "Cosmos", targets: ["Cosmos"]),
        .library(name: "IBCCore", targets: ["IBCCore"]),
        .library(name: "Client", targets: ["Client"]),
        .library(name: "Connection", targets: ["Connection"]),
        .library(name: "Channel", targets: ["Channel"]),
        .library(name: "Port", targets: ["Port"]),
        .library(name: "Commitment", targets: ["Commitment"]),
        .library(name: "Host", targets: ["Host"]),
        .library(name: "LCSoloMachine", targets: ["LCSoloMachine"]),
        .library(name: "LCTendermint", targets: ["LCTendermint"]),
        .library(name: "LCLocalhost", targets: ["LCLocalhost"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        //.package(name: "name-service", url: "https://github.com/CosmosSwift/swift-coin", .branch("master")),
        //.package(name: "swift-nio", url: "https://github.com/apple/swift-nio.git", from: "2.0.0"),

    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "Cosmos", dependencies: [], path: "./Sources/Cosmos"),
        .target(name: "IBCCore", dependencies: [], path: "./Sources/Core/Core"),
        .target(name: "Client", dependencies: [], path: "./Sources/Core/02-Client"),
        .target(name: "Connection", dependencies: [], path: "./Sources/Core/03-Connection"),
        .target(name: "Channel", dependencies: [], path: "./Sources/Core/04-Channel"),
        .target(name: "Port", dependencies: [], path: "./Sources/Core/05-Port"),
        .target(name: "Commitment", dependencies: [], path: "./Sources/Core/23-Commitment"),
        .target(name: "Host", dependencies:
                    [ "Cosmos",
                    ], path: "./Sources/Core/24-Host"),
        .target(name: "LCSoloMachine", dependencies: [], path: "./Sources/LightClients/06-SoloMachine"),
        .target(name: "LCTendermint", dependencies: [], path: "./Sources/LightClients/07-Tendermint"),
        .target(name: "LCLocalhost", dependencies: [], path: "./Sources/LightClients/09-Localhost"),
        .target(
            name: "Transfer",
            dependencies: ["IBCCore"],
            path: "./Sources/Applications/Transfer"),
        .testTarget(
            name: "swift-ibcTests",
            dependencies: ["IBCCore"]),
    ]
)
