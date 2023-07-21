@testable import YouTubeChannels
import XCTVapor

final class AppTests: XCTestCase {
    func testHelloWorld() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try await configure(app)

        let channels = try await app.youTubeChannels.fetchChannels()
        app.logger.info("\(channels.count) channels fetched")
        
        let youTubeChannels = try await app.youTubeChannels.fetchYouTubeChannels()
        app.logger.info("\(youTubeChannels.count) YouTube channels fetched")
    }
}
