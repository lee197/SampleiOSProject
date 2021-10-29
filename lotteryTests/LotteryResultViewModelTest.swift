//
//  LotteryResultViewModelTest.swift
//  lotteryTests
//
//  Created by Jason Lee on 29/10/2021.
//

import XCTest
@testable import lottery

class LotteryResultViewModelTest: XCTestCase {
    var sut: LotteryResultViewModel!
    var mocks: MockLotteryRepository!
    
    override func setUpWithError() throws {
        mocks = MockLotteryRepository()
        sut = LotteryResultViewModel.init(apiClient: mocks, lotteryCalculator: LotteryCalculator())
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mocks = nil
    }
    
    func testFetchLotteryResultSucceed() {
        mocks.IsFetchLotteryResultSucceeded = true
        let expect = XCTestExpectation(description: "fetch successfully")
        sut.updateResultViewClosure = { info in
            expect.fulfill()
            XCTAssertEqual(info!.id, 1)
            XCTAssertEqual(info!.result, "10")
        }
        
        sut.initResultFetch(ticketNumber: "1")
        wait(for: [expect], timeout: 1.0)
    }
    
    func testFetchLotteryResultFailed() {
        mocks.IsFetchLotteryResultSucceeded = false
        let expect = XCTestExpectation(description: "fetch failed")
        sut.showAlertClosure = { alert in
            expect.fulfill()
            XCTAssertEqual(alert!, "Please wait a while and re-launch the app")
        }
        
        sut.initResultFetch(ticketNumber: "1")
        wait(for: [expect], timeout: 1.0)
    }
    
}
