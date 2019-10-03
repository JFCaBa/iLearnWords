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
    var words: [Words]?
    
    override func setUp() {
        words = coreDataManager.fetchAllByEntity(UserDefaults.Entity.Words) as? [Words]
    }

    override func tearDown() {

    }

    func testNumberOfWords() {
        let viewModel = MainWordsVM(wordsData: words!)
        XCTAssertGreaterThan(viewModel.numberOfWords, 0)
    }
    
    func testViewModel() {
        let viewModel = MainWordsVM(wordsData: words!)
        for(index, _) in words!.enumerated() {
            XCTAssertNotNil(viewModel.viewModel(for: index))
        }
    }
    
    func testOriginalWord_Undefined() {
        for(index, _) in words!.enumerated() {
            let viewModel = MainWordVM(word: words![index])
            XCTAssertNotEqual(viewModel.originalWord, "Undefined")
        }
    }
    
    func testTranslatedWord_Undefined() {
        for(index, _) in words!.enumerated() {
            let viewModel = MainWordVM(word: words![index])
            XCTAssertNotEqual(viewModel.translatedWord, "Undefined")
        }
    }
}
