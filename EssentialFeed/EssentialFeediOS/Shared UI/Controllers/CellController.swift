//
//  CellController.swift
//  EssentialFeediOS
//
//  Created by Shinzan Takata on 2020/10/02.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import UIKit

public struct CellController {
    let id: UUID
    let dataSoruce: UITableViewDataSource
    let delegate: UITableViewDelegate?
    let prefetchDataSource: UITableViewDataSourcePrefetching?

    public init(id: UUID, dataSoruce: UITableViewDataSource,
                delegate: UITableViewDelegate? = nil,
                prefetchDataSource: UITableViewDataSourcePrefetching? = nil) {
        self.id = id
        self.dataSoruce = dataSoruce
        self.delegate = delegate
        self.prefetchDataSource = prefetchDataSource
    }
}

