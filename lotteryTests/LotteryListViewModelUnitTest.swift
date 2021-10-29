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
        mocks = MockLotteryRepository()
        sut = LotteryListViewModel.init(apiClient: mocks)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mocks = nil
    }
    
    func testFetchLotteryListSucceed() {
        mocks.IsFetchLotteryListSucceeded = true
        let expect = XCTestExpectation(description: "fetch successfully")

        sut.reloadTableViewClosure = { info in
            expect.fulfill()
            XCTAssertEqual(info, [1,2,3,4,5])
        }
        
        sut.initListFetch()
        wait(for: [expect], timeout: 1.0)
    }
    
    func testFetchLotteryListFailed() {
        mocks.IsFetchLotteryListSucceeded = false
        let expect = XCTestExpectation(description: "fetch failed")
        sut.showAlertClosure = { alert in
            expect.fulfill()
            XCTAssertEqual(alert!, "Please wait a while and re-launch the app")
        }
        
        sut.initListFetch()
        wait(for: [expect], timeout: 1.0)
    }

}
