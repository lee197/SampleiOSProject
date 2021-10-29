//
//  LotteryDetailViewModelTest.swift
//  lotteryTests
//
//  Created by Jason Lee on 29/10/2021.
//

import XCTest
@testable import lottery

class LotteryDetailViewModelTest: XCTestCase {
    var sut: LotteryDetailViewModel!
    var mocks: MockLotteryRepository!
    
    override func setUpWithError() throws {
        mocks = MockLotteryRepository()
        sut = LotteryDetailViewModel.init(apiClient: mocks, lotteryCalculator: LotteryCalculator())
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mocks = nil
    }
    
    func testFetchLotteryDetailSucceed() {
        mocks.IsFetchLotteryDetailSucceeded = true
        let expect = XCTestExpectation(description: "fetch successfully")
        sut.updateDetailViewClosure = { info in
            expect.fulfill()
            XCTAssertEqual(info!.id, 1)
            XCTAssertEqual(info!.result, "10")
        }
        
        sut.initDetailFetch(ticketNumber: "1")
        wait(for: [expect], timeout: 1.0)
    }
    
    func testFetchLotteryDetailFailed() {
        mocks.IsFetchLotteryDetailSucceeded = false
        let expect = XCTestExpectation(description: "fetch failed")
        sut.showAlertClosure = { alert in
            expect.fulfill()
            XCTAssertEqual(alert!, "Please wait a while and re-launch the app")
        }
        
        sut.initDetailFetch(ticketNumber: "1")
        wait(for: [expect], timeout: 1.0)
    }
    
}
