//
//  MainLanguagesVMTest.swift
//  iLearnWordsTests
//
//  Created by Jose Catala on 03/10/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import XCTest
@testable import iLearnWords

class MainLanguagesVMTest: XCTestCase {

    let coreDataManager: CoreDataManager = CoreDataManager()
    var languages: [Languages]?
    
    override func setUp() {
        languages = coreDataManager.fetchAllByEntity(UserDefaults.Entity.Languages) as? [Languages]
    }

    override func tearDown() {
    }

    func titleTest() {
        for(_, element) in (languages?.enumerated())! {
            let viewModel = MainLanguageVM(language: element)
            XCTAssertNotEqual(viewModel.title, "Undefined")
        }
    }
    
    func sayOriginalTest() {
        for(_, element) in (languages?.enumerated())! {
            let viewModel = MainLanguageVM(language: element)
            XCTAssertNotEqual(viewModel.sayOriginal, "Undefined")
        }
    }
    
    func sayTranslatedTest() {
        for(_, element) in (languages?.enumerated())! {
            let viewModel = MainLanguageVM(language: element)
            XCTAssertNotEqual(viewModel.sayTranslated, "Undefined")
        }
    }
}
