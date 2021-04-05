// swift-tools-version:5.4
import PackageDescription

let package = Package(
    name: "swift-ibc",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "Transfer", targets: ["Transfer"]),
        .library(
            name: "IBCCore",
            targets: ["IBCCore"]
        ),
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
        .package(name: "swift-cosmos", url: "https://github.com/CosmosSwift/swift-cosmos", .branch("feature/ibc")),
    ],
    targets: [
        .target(
            name: "Transfer",
            dependencies: [
                .target(name: "IBCCore"),
                .product(name: "Cosmos", package: "swift-cosmos"),
                .product(name: "Params", package: "swift-cosmos"),
                .product(name: "Auth", package: "swift-cosmos"),
                .product(name: "Bank", package: "swift-cosmos"),
                .product(name: "Capability", package: "swift-cosmos"),
            ],
            path: "./Sources/Applications/Transfer"
        ),
        .target(
            name: "IBCCore",
            dependencies: [
                .target(name: "Client"),
                .target(name: "Connection"),
                .target(name: "Channel"),
                .target(name: "Port"),
                .target(name: "Commitment"),
                .target(name: "Host"),
            ],
            path: "./Sources/Core/Core"
        ),
        .target(
            name: "Client",
            dependencies: [
                .product(name: "Cosmos", package: "swift-cosmos"),
            ],
            path: "./Sources/Core/02-Client"
        ),
        .target(
            name: "Connection",
            dependencies: [],
            path: "./Sources/Core/03-Connection"
        ),
        .target(
            name: "Channel",
            dependencies: [
                .product(name: "Cosmos", package: "swift-cosmos"),
                .target(name: "Host"),
            ],
            path: "./Sources/Core/04-Channel"
        ),
        .target(
            name: "Port",
            dependencies: [
                .product(name: "Cosmos", package: "swift-cosmos"),
                .product(name: "Capability", package: "swift-cosmos"),
                .target(name: "Channel"),
            ],
            path: "./Sources/Core/05-Port"
        ),
        .target(
            name: "Commitment",
            dependencies: [],
            path: "./Sources/Core/23-Commitment"
        ),
        .target(
            name: "Host",
            dependencies: [
                .product(name: "Cosmos", package: "swift-cosmos"),
            ],
            path: "./Sources/Core/24-Host"
        ),
        .target(
            name: "LCSoloMachine",
            dependencies: [],
            path: "./Sources/LightClients/06-SoloMachine"
        ),
        .target(
            name: "LCTendermint",
            dependencies: [],
            path: "./Sources/LightClients/07-Tendermint"
        ),
        .target(
            name: "LCLocalhost",
            dependencies: [],
            path: "./Sources/LightClients/09-Localhost"
        ),
        .testTarget(
            name: "swift-ibcTests",
            dependencies: ["IBCCore"]
        ),
    ]
)
