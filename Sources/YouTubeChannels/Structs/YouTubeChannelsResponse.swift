import Foundation
import Vapor


struct YouTubeChannelsResponse: Codable {
    
    let pageInfo: FetchChannelPageInfo
    
    let items: [YouTubeChannelItemResponse]
    
}

extension YouTubeChannelsResponse: Content { }


// MARK: - Youtube Channel Thumbnail

struct FetchChannelPageInfo: Codable {
    
    let totalResults: Int
    
    let resultsPerPage: Int
    
}


// MARK: - Youtube Channel Item

struct YouTubeChannelItemResponse: YouTubeChannel, Codable {
    
    let id: String
    
    let snippet: YouTubeChannelSnippet
    
    var channelID: String {
        return self.id
    }

    var title: String {
        return self.snippet.title
    }

    var description: String {
        return self.snippet.description
    }

    var customURL: String {
        return self.snippet.customURL
    }

    var publishedAt: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: self.snippet.publishedAt)
    }

    var thumbnailURL: String? {
        return self.snippet.thumbnails.high.url
    }
    
}


// MARK: - YouTube Channel Snippet

struct YouTubeChannelSnippet: Codable {
    
    let title: String
    
    let description: String
    
    let customURL: String
    
    let publishedAt: String
    
    let thumbnails: YouTubeChannelThumbnails
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case customURL = "customUrl"
        case publishedAt
        case thumbnails
    }
    
}


// MARK: - Youtube Channel Thumbnail

struct YouTubeChannelThumbnails: Codable {
    
    let standard: YouTubeChannelThumbnail
    
    let medium: YouTubeChannelThumbnail
    
    let high: YouTubeChannelThumbnail
    
    enum CodingKeys: String, CodingKey {
        case standard = "default"
        case medium = "medium"
        case high = "high"
    }
    
}


struct YouTubeChannelThumbnail: Codable {
    
    let url: String?
    
    let width: Int
    
    let height: Int
    
}
