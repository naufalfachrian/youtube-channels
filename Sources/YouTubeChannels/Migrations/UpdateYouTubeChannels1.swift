import Fluent


struct UpdateYouTubeChannels1: AsyncMigration {

    func prepare(on database: Database) async throws {
        try await database.schema("youtube_channels")
            .unique(on: "channel_id")
            .unique(on: "custom_url")
            .update()
    }

    func revert(on database: Database) async throws {
        try await database.schema("youtube_channels")
            .deleteUnique(on: "channel_id")
            .deleteUnique(on: "custom_url")
            .update()
    }

}