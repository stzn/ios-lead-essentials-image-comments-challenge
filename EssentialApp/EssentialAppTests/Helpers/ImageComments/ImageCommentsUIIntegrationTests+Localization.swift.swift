//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import EssentialFeed
import Foundation
import XCTest

extension ImageCommentsUIIntegrationTests {
  func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
    let table = "ImageComments"
    let bundle = Bundle(for: ImageCommentsLocalizedString.self)
    let value = bundle.localizedString(forKey: key, value: nil, table: table)
    if value == key {
      XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
    }
    return value
  }
}
