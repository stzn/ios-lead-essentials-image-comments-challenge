//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation
import XCTest
import EssentialFeed

extension ImageCommentsUIIntegrationTests {
    func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }

    func sharedLocalized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = SharedLocalizationInfo.stringsFileName
        let bundle = Bundle(for: Presenter<NeverView>.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }

    private class NeverView: ViewPresenter {
        func display(_ viewModel: Never) {}
        typealias ViewModel = Never
    }
}
