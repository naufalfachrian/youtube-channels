import Fluent


extension Array where Element == any YouTubeChannel {

    func store(on db: Database, logger: Logger? = nil) async throws {
        for youTubeChannel in self {
            if let update = try await YouTubeChannelModel.query(on: db)
                .filter(\.$channelID, .equal, youTubeChannel.channelID)
                .first() {
                    try await update.update(youTubeChannel: youTubeChannel, on: db, logger: logger)
                    continue
                }
            let create = YouTubeChannelModel(from: youTubeChannel)
            logger?.info("Created \(youTubeChannel.title)")
            try await create.save(on: db)
        }
    }

}


extension YouTubeChannelModel {

    func update(
        youTubeChannel: YouTubeChannel, 
        on db: Database, 
        logger: Logger? = nil
    ) async throws {
        var hasUpdate = false
        if self.title != youTubeChannel.title {
            self.title = youTubeChannel.title
            hasUpdate = true
        }
        if self.description != youTubeChannel.description {
            self.description = youTubeChannel.description
            hasUpdate = true
        }
        if self.customURL != youTubeChannel.customURL {
            self.customURL = youTubeChannel.customURL
            hasUpdate = true
        }
        if self.thumbnailURL != youTubeChannel.thumbnailURL {
            self.thumbnailURL = youTubeChannel.thumbnailURL
            hasUpdate = true
        }
        if hasUpdate {
            logger?.info("Updated \(youTubeChannel.title)")
            try await self.update(on: db)
        } else {
            logger?.info("No update for \(youTubeChannel.title)")
        }
    }

}
