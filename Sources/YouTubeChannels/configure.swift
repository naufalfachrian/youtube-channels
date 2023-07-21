import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(configuration: SQLPostgresConfiguration(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    guard let dataSourceURL = Environment.get("DATASOURCE") else {
        fatalError("DATASOURCE environment variable not set")
    }
    app.youTubeChannels.use(dataSourceURL: dataSourceURL)

    guard let googleAPIKey = Environment.get("GOOGLE_API_KEY") else {
        fatalError("GOOGLE_API_KEY environment variable not set")
    }
    app.googleAPI.use(key: googleAPIKey)

    app.migrations.add(CreateYouTubeChannels())

    app.commands.use(SyncCommand(), as: "sync")

    // register routes
    try routes(app)
}
