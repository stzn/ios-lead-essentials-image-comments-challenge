//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import EssentialFeed
import Foundation
import XCTest

extension XCTestCase {
  func sharedLocalized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
    let table = "Shared"
    let bundle = Bundle(for: Presenter<AnyView, Never>.self)
    let value = bundle.localizedString(forKey: key, value: nil, table: table)
    if value == key {
      XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
    }
    return value
  }

  private class AnyView: View {
    typealias Content = Never
    func display(_ model: ViewModel<Never>) {}
  }
}
