import Vapor
import Queues


struct SyncJob: AsyncScheduledJob {

    func run(context: QueueContext) async throws {
        context.logger.info("Syncing YouTube Channels data ...")
        try await context.application.youTubeChannels.syncYouTubeChannels()
        context.application.redis.publish("done", to: "youtube-channels-sync")
    }

}
