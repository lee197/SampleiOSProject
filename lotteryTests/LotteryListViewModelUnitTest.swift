//
//  LotteryListViewModelUnitTest.swift
//  lotteryTests
//
//  Created by Jason Lee on 29/10/2021.
//

import XCTest
@testable import lottery

class LotteryListViewModelUnitTest: XCTestCase {
    var sut: LotteryListViewModel!
    var mocks: MockLotteryRepository!
    
    override func setUpWithError() throws {
        sut = LotteryListViewModel()
        mocks = MockLotteryRepository()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mocks = nil
    }
    
    func testFetchLotteryListSucceed() {}
    
    func testFetchLotteryListFailed() {}

}
