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
    var userDefaults: UserDefaults!

    override func setUpWithError() throws {
        mocks = MockLotteryRepository()
        userDefaults = UserDefaults(suiteName: "fake_file")
        userDefaults.removePersistentDomain(forName: "fake_file")
        
        sut = LotteryResultViewModel(apiClient: mocks,
                                     lotteryCalculator: LotteryCalculator(),
                                     userDefault: userDefaults)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mocks = nil
    }
    
    func testFetchLotteryResultSucceed() {
        mocks.IsFetchLotteryResultSucceeded = true
        let expect = XCTestExpectation(description: "fetch successfully")
        sut.updateResultViewClosure = { [weak self] info in
            guard let self = self else { return }
            expect.fulfill()
            XCTAssertEqual(info!.id, 1)
            XCTAssertEqual(info!.result, "10")
            let val = self.userDefaults.integer(forKey: "totalAmount")
            XCTAssertEqual(val, 10)
        }
        
        sut.initResultFetch(ticketNumber: "1")
        wait(for: [expect], timeout: 1.0)
    }
    
    func testFetchLotteryResultFailed() {
        mocks.IsFetchLotteryResultSucceeded = false
        let expect = XCTestExpectation(description: "fetch failed")
        sut.showAlertClosure = { alert in
            expect.fulfill()
            XCTAssertEqual(alert!, "Server error, please try again")
        }
        
        sut.initResultFetch(ticketNumber: "1")
        wait(for: [expect], timeout: 1.0)
    }
    
}
