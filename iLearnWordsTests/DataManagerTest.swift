//
//  DataManagerTest.swift
//  iLearnWordsTests
//
//  Created by Jose Catala on 03/10/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import XCTest
@testable import iLearnWords

class DataManagerTest: XCTestCase {

    private lazy var dataManager = {
        return DataManager(APIKey: API.key)
    }()

    func testTranslation() {
        let translateWord = XCTestExpectation(description: "Translate word")
        dataManager.tranlationFor(word: "да") { (response, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            translateWord.fulfill()
        }
        wait(for: [translateWord], timeout: 30)
    }
}
