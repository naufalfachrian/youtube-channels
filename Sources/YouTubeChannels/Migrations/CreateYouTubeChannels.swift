import Fluent


struct CreateYouTubeChannels: AsyncMigration {

    func prepare(on database: Database) async throws {
        try await database.schema("youtube_channels")
            .id()
            .field("channel_id", .string, .required)
            .field("title", .string, .required)
            .field("description", .sql(.text), .required)
            .field("custom_url", .string, .required)
            .field("thumbnail_url", .string)
            .field("published_at", .datetime)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("youtube_channels").delete()
    }

}
