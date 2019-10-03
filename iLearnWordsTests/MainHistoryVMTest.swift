//
//  MainHistoryVMTest.swift
//  iLearnWordsTests
//
//  Created by Jose Catala on 03/10/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import XCTest
@testable import iLearnWords

class MainHistoryVMTest: XCTestCase {

    let coreDataManager: CoreDataManager = CoreDataManager()
    var histories: [History]?
    
    override func setUp() {
        histories = coreDataManager.fetchAllByEntity(UserDefaults.Entity.History) as? [History]
    }

    override func tearDown() {
    }

    func testNumberOfHistories() {
        let viewModel = MainHistoriesVM(historiesData: histories!)
        XCTAssertGreaterThan(viewModel.numberOfHistories, 0)
    }
    
    func testViewModel() {
        let viewModel = MainHistoriesVM(historiesData: histories!)
        for(index, _) in histories!.enumerated() {
            XCTAssertNotNil(viewModel.viewModel(for: index))
        }
    }
    
    func testTitle_Undefined() {
        for(index, _) in histories!.enumerated() {
            let viewModel = MainHistoryVM(history: histories![index])
            XCTAssertNotEqual(viewModel.title, "Undefined")
        }
    }
    
    func testIsSelected() {
        var counter = 0
        for(index, _) in histories!.enumerated() {
            let viewModel = MainHistoryVM(history: histories![index])
            if viewModel.isSelected {
                counter += 1
            }
        }
        XCTAssertEqual(counter, 1)
    }
}
