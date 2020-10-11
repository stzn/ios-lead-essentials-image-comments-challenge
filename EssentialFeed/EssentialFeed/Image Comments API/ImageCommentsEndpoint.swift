//
//  ImageCommentsEndpoint.swift
//  EssentialFeed
//
//  Created by Shinzan Takata on 2020/10/11.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public enum ImageCommentsEndpoint {
    case get(UUID)

    public func url(baseURL: URL) -> URL {
        switch self {
        case .get(let id):
            return baseURL.appendingPathComponent("/image/\(id)/comments")
        }
    }
}

