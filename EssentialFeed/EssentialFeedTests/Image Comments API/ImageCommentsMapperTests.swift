//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentsMapperTests: XCTestCase {
    func test_map_deliversErrorOnNon2xxHTTPResponse() throws {
        let samples = [199, 300, 400, 500]

        try samples.forEach { code in
            XCTAssertThrowsError(try ImageCommentsMapper.map(anyData(), from: HTTPURLResponse(statusCode: code)))
        }
    }

    func test_map_deliversErrorOn2xxHTTPResponseWithInvalidJSON() throws {
        let samples = [200, 201, 299]

        try samples.forEach { code in
            let invalidJSON = Data("invalid json".utf8)
            XCTAssertThrowsError(try ImageCommentsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: code)))
        }
    }

    func test_map_deliversNoItemsOn2xxHTTPResponseWithEmptyJSONList() throws {
        let samples = [200, 201, 299]

        try samples.forEach { code in
            let emptyListJSON = makeItemsJSON([])
            let result = try ImageCommentsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: code))
            XCTAssertEqual(result, [])
        }
    }

    func test_map_deliversItemsOn2xxHTTPResponseWithJSONItems() throws {
        let item1 = makeItem(id: UUID(),
                             message: "a message",
                             createdAt: (Date(timeIntervalSince1970: 0), "1970-01-01T00:00:00+0000"),
                             username: "a username")

        let item2 = makeItem(id: UUID(),
                             message: "another message",
                             createdAt: (Date(timeIntervalSince1970: 1), "1970-01-01T00:00:01+0000"),
                             username: "another username")

        let items = [item1.model, item2.model]

        let samples = [200, 201, 299]

        try samples.forEach { code in
            let json = makeItemsJSON([item1.json, item2.json])
            let result = try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: code))
            XCTAssertEqual(result, items)
        }
    }

    // MARK: - Helpers
    private func makeItem(id: UUID, message: String, createdAt: (date: Date, iso8601String: String), username: String) -> (model: ImageComment, json: [String: Any]) {
        let item = ImageComment(id: id,
                                message: message,
                                createdAt: createdAt.date,
                                username: username)

        let json = [
            "id": id.uuidString,
            "message": message,
            "created_at": createdAt.iso8601String
            ,
            "author": [
                "username": username
            ]
        ].compactMapValues { $0 }

        return (item, json)
    }

    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = ["items": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}
