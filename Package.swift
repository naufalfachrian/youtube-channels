// swift-tools-version:5.8
import PackageDescription

let package = Package(
    name: "youtube-channels",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.77.1"),
        // 🗄 An ORM for SQL and NoSQL databases.
        .package(url: "https://github.com/vapor/fluent.git", from: "4.8.0"),
        // ὁ8 Fluent driver for Postgres.
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.7.2"),
    ],
    targets: [
        .executableTarget(
            name: "YouTubeChannels",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "Vapor", package: "vapor")
            ]
        ),
        .testTarget(name: "YouTubeChannelsTests", dependencies: [
            .target(name: "YouTubeChannels"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)
