import Fluent
import Vapor


protocol YouTubeChannel {

    var channelID: String { get }

    var title: String { get }

    var description: String { get }

    var customURL: String { get }

    var thumbnailURL: String? { get }

    var publishedAt: Date? { get }

}


final class YouTubeChannelModel: YouTubeChannel, Model {

    static let schema = "youtube_channels"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "channel_id")
    var channelID: String

    @Field(key: "title")
    var title: String

    @Field(key: "description")
    var description: String

    @Field(key: "custom_url")
    var customURL: String

    @Field(key: "thumbnail_url")
    var thumbnailURL: String?

    @Field(key: "published_at")
    var publishedAt: Date?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    init() { }

    init(
        channelID: String, 
        title: String, 
        description: String, 
        customURL: String, 
        thumbnailURL: String?, 
        publishedAt: Date?
    ) {
        self.channelID = channelID
        self.title = title
        self.description = description
        self.customURL = customURL
        self.thumbnailURL = thumbnailURL
        self.publishedAt = publishedAt
    }

    init(from channel: YouTubeChannel) {
        self.channelID = channel.channelID
        self.title = channel.title
        self.description = channel.description
        self.customURL = channel.customURL
        self.thumbnailURL = channel.thumbnailURL
        self.publishedAt = channel.publishedAt
    }

}


extension YouTubeChannelModel: Content { }
