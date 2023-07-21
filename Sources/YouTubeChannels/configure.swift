import NIOSSL
import Fluent
import FluentPostgresDriver
import QueuesRedisDriver
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

    app.middleware.use(app.sessions.middleware)

    let redisConfiguration = try RedisConfiguration(
        hostname: Environment.get("REDIS_HOST") ?? "", 
        port: Environment.get("REDIS_PORT").flatMap(Int.init(_:)) ?? 6379, 
        password: Environment.get("REDIS_PASSWORD")
    )

    app.queues.use(.redis(redisConfiguration))

    let scheduleEveryDayAtHour = Environment.get("SCHEDULE_EVERY_DAY_AT_HOUR").flatMap(Int.init(_:)) ?? 23
    let scheduleEveryDayAtMinute = Environment.get("SCHEDULE_EVERY_DAY_AT_MINUTE").flatMap(Int.init(_:)) ?? 0
    app.queues.schedule(SyncJob())
        .daily()
        .at(.init(integerLiteral: scheduleEveryDayAtHour), .init(integerLiteral: scheduleEveryDayAtMinute))

    app.commands.use(SyncCommand(), as: "sync")

    // register routes
    try routes(app)
}
