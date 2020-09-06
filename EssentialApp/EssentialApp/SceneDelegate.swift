//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import UIKit
import CoreData
import Combine
import EssentialFeed

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var store: FeedStore & FeedImageDataStore = {
        try! CoreDataFeedStore(
            storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("feed-store.sqlite"))
    }()
    
    private lazy var localFeedLoader: LocalFeedLoader = {
        LocalFeedLoader(store: store, currentDate: Date.init)
    }()
    
    convenience init(httpClient: HTTPClient, store: FeedStore & FeedImageDataStore) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        let feedViewController = FeedUIComposer.feedComposedWith(
            feedLoader: makeRemoteFeedLoaderWithLocalFallback,
            imageLoader: makeLocalImageLoaderWithRemoteFallback)
        
        let navigationController = UINavigationController(
            rootViewController: feedViewController)
        window?.rootViewController = navigationController
        
        feedViewController.didSelectFeedImage = { [navigationController, feedViewController] model in
            let commentsViewController = ImageCommentsUIComposer.imageCommnetsComposedWith(
                feed: model,
                imageCommentsLoader: self.makeRemoteImageCommentsLoader)
            
            feedViewController.navigationItem.backBarButtonItem
                = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            
            navigationController.pushViewController(commentsViewController, animated: true)
        }
        
        window?.makeKeyAndVisible()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        localFeedLoader.validateCache { _ in }
    }
    
    private func makeRemoteFeedLoaderWithLocalFallback() -> AnyPublisher<[FeedImage], Swift.Error> {
        let remoteURL = URL(string: "http://image-comments-challenge.essentialdeveloper.com/feed")!
        
        return httpClient
            .getPublisher(from: remoteURL)
            .tryMap(FeedImagesMapper.map)
            .caching(to: localFeedLoader)
            .fallback(to: localFeedLoader.loadPublisher)
    }
    
    private func makeLocalImageLoaderWithRemoteFallback(url: URL) -> AnyPublisher<Data, Swift.Error> {
        let localImageLoader = LocalFeedImageDataLoader(store: store)
        
        return localImageLoader
            .loadImageDataPublisher(from: url)
            .fallback(to: { [self] in
                self.httpClient
                    .getPublisher(from: url)
                    .tryMap(FeedImageDataMapper.map)
                    .caching(to: localImageLoader, using: url)
            })
    }
    
    private func makeRemoteImageCommentsLoader(_ model: FeedImage) -> AnyPublisher<[ImageComment], Swift.Error> {
        let remoteURL = URL(string: "http://image-comments-challenge.essentialdeveloper.com/image/\(model.id)/comments")!
        return httpClient
            .getPublisher(from: remoteURL)
            .tryMap(ImageCommentsMapper.map)
            .eraseToAnyPublisher()
    }
}
