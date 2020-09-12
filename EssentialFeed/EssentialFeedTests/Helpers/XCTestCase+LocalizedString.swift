//
// Copyright © 2020 Essential Developer. All rights reserved.
//

import EssentialFeed
import Foundation
import XCTest

extension XCTestCase {
  typealias LocalizedBundle = (bundle: Bundle, localization: String)

  func allLocalizationBundles(in bundle: Bundle, file: StaticString = #file, line: UInt = #line)
    -> [LocalizedBundle]
  {
    return bundle.localizations.compactMap { localization in
      guard
        let path = bundle.path(forResource: localization, ofType: "lproj"),
        let localizedBundle = Bundle(path: path)
      else {
        XCTFail(
          "Couldn't find bundle for localization: \(localization)", file: file, line: line
        )
        return nil
      }

      return (localizedBundle, localization)
    }
  }

  func allLocalizedStringKeys(
    in bundles: [LocalizedBundle], table: String, file: StaticString = #file, line: UInt = #line
  ) -> Set<String> {
    return bundles.reduce([]) { (acc, current) in
      guard
        let path = current.bundle.path(forResource: table, ofType: "strings"),
        let strings = NSDictionary(contentsOfFile: path),
        let keys = strings.allKeys as? [String]
      else {
        XCTFail(
          "Couldn't load localized strings for localization: \(current.localization)",
          file: file, line: line)
        return acc
      }

      return acc.union(Set(keys))
    }
  }

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
