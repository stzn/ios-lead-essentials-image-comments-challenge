//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import EssentialFeed
import XCTest

class ImageCommentsLocalizationTests: XCTestCase {

  func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
    let table = "ImageComments"
    let presentationBundle = Bundle(for: ImageCommentsLocalizedString.self)
    let localizationBundles = allLocalizationBundles(in: presentationBundle)
    let localizedStringKeys = allLocalizedStringKeys(in: localizationBundles, table: table)

    localizationBundles.forEach { (bundle, localization) in
      localizedStringKeys.forEach { key in
        let localizedString = bundle.localizedString(forKey: key, value: nil, table: table)

        if localizedString == key {
          let language = Locale.current.localizedString(forLanguageCode: localization) ?? ""

          XCTFail(
            "Missing \(language) (\(localization)) localized string for key: '\(key)' in table: '\(table)'"
          )
        }
      }
    }
  }
}
