import Fluent
import Vapor


struct YouTubeChannelsController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let grouped = routes.grouped("")
        grouped.get(use: index)
    }

    func index(req: Request) async throws -> Page<YouTubeChannelModel> {
        try await YouTubeChannelModel.query(on: req.db).paginate(for: req)
    }

}
