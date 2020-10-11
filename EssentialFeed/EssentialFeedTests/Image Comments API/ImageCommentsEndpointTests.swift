//
//  ImageCommentsEndpointTests.swift
//  EssentialFeedTests
//
//  Created by Shinzan Takata on 2020/10/11.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentsEndpointTests: XCTestCase {
    func test_imageComments_endpointURL() {
        let id = UUID()
        let baseURL = URL(string: "http://base-url.com")!
        let received = ImageCommentsEndpoint.get(id).url(baseURL: baseURL)
        let expected = URL(string: "http://base-url.com/image/\(id)/comments")!
        XCTAssertEqual(received, expected)
    }
}
