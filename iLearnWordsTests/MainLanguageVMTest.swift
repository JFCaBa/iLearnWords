//
//  MainLanguageVMTest.swift
//  iLearnWordsTests
//
//  Created by Jose Catala on 03/10/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import XCTest
@testable import iLearnWords

class MainLanguageVMTest: XCTestCase {

    let coreDataManager: CoreDataManager = CoreDataManager()
    var languages: [Languages]?
    
    override func setUp() {
        languages = coreDataManager.fetchAllByEntity(UserDefaults.Entity.Languages) as? [Languages]
    }

    func testTitle() {
        for(_, element) in (languages?.enumerated())! {
            let viewModel = MainLanguageVM(language: element)
            XCTAssertNotEqual(viewModel.title, "Undefined")
        }
    }
    
    func testSayOriginal() {
        for(_, element) in (languages?.enumerated())! {
            let viewModel = MainLanguageVM(language: element)
            XCTAssertNotEqual(viewModel.sayOriginal, "Undefined")
        }
    }
    
    func testSayTranslated() {
        for(_, element) in (languages?.enumerated())! {
            let viewModel = MainLanguageVM(language: element)
            XCTAssertNotEqual(viewModel.sayTranslated, "Undefined")
        }
    }
    
    func testNumberOfLanguages() {
        let viewModel = MainLanguagesVM(languagesData: languages!)
        XCTAssertGreaterThan(viewModel.numberOfWords, 0)
    }
}
