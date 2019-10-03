//
//  JSONDecodableTest.swift
//  iLearnWordsTests
//
//  Created by Jose Catala on 03/10/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import XCTest
@testable import iLearnWords

class JSONDecodableTest: XCTestCase {

    /// Load the Stub with the JSON example server response
    func loadStubFromBundle(withName name: String, ext: String) -> Data {
        let bundle = Bundle(for: classForCoder)
        let url = bundle.url(forResource: name, withExtension: ext)
        return try! Data(contentsOf: url!)
    }
    
    func testDecodeJSON() {
        let data = loadStubFromBundle(withName: "response", ext: "json")
        do {
            let translationData: TranslationData = try JSONDecoder.decode(data: data)
            XCTAssertEqual(translationData.code, 200)
            XCTAssertEqual(translationData.lang, "ru-en")
            XCTAssertEqual(translationData.text[0], "Yes")
        }
        catch {
            XCTAssertNil(error)
        }
    }
}
