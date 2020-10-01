//
//  LoaderPresentationAdapter.swift
//  EssentialApp
//
//  Created by Shinzan Takata on 2020/09/24.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Combine
import Foundation
import EssentialFeed
import EssentialFeediOS

final class LoaderPresentationAdapter<Resource, View: ResourceView> {
    private let loader: () -> AnyPublisher<Resource, Swift.Error>
    private var cancellable: Cancellable?
    var presenter: Presenter<Resource, View>?

    init(loader: @escaping () -> AnyPublisher<Resource, Swift.Error>) {
        self.loader = loader
    }

    func loadContent() {
        presenter?.didStartLoadingView()

        cancellable = loader()
            .dispatchOnMainQueue()
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished: break

                    case let .failure(error):
                        self?.presenter?.didFinishLoadingView(with: error)
                    }
                }, receiveValue: { [weak self] resource in
                    self?.presenter?.didFinishLoadingView(with: resource)
                })
    }
}

extension LoaderPresentationAdapter: FeedImageCellControllerDelegate {
    func didRequestImage() {
        loadContent()
    }

    func didCancelImageRequest() {
        cancellable?.cancel()
        cancellable = nil
    }
}
