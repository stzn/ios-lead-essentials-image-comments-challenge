//
//  FeedEndpoint.swift
//  EssentialFeed
//
//  Created by Shinzan Takata on 2020/10/11.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public enum FeedEndpoint {
    case get

    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            return baseURL.appendingPathComponent("feed")
        }
    }
}

