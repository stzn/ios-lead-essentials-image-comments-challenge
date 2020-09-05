//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import Foundation

final class FeedImagesMapper {
    private struct Root: Decodable {
        let items: [RemoteFeedImage]

        struct RemoteFeedImage: Decodable {
            let id: UUID
            let description: String?
            let location: String?
            let image: URL
        }

        var images: [FeedImage] {
            items.map {
                FeedImage(
                    id: $0.id, description: $0.description, location: $0.location, url: $0.image)
            }
        }
    }

    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [FeedImage] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        return root.images
    }
}