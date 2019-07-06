// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "pcinfo",
    products: [
        .library(name: "pcinfo", targets: ["App"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),

        // 🔵 Swift ORM (queries, models, relations, etc) built on SQLite 3.
        .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0"),
        // html parser
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "1.7.4"),
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentSQLite", "Vapor","SwiftSoup"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

