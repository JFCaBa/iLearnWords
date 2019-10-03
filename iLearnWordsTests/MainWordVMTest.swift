//
//  MainWordVMTest.swift
//  iLearnWordsTests
//
//  Created by Jose Catala on 03/10/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import XCTest
@testable import iLearnWords

class MainWordVMTest: XCTestCase {
    
    let coreDataManager: CoreDataManager = CoreDataManager()
    
    override func setUp() {

    }

    override func tearDown() {

    }

    func testOriginalWord_Undefined() {
        let words = coreDataManager.fetchAllByEntity(UserDefaults.Entity.Words) as! [Words]
        for(index, _) in words.enumerated() {
            let viewModel = MainWordVM(word: words[index])
            XCTAssertNotEqual(viewModel.originalWord, "Undefined")
        }
    }
    
    func testTranslatedWord_Undefined() {
        let words = coreDataManager.fetchAllByEntity(UserDefaults.Entity.Words) as! [Words]
        for(index, _) in words.enumerated() {
            let viewModel = MainWordVM(word: words[index])
            XCTAssertNotEqual(viewModel.translatedWord, "Undefined")
        }
    }

}
