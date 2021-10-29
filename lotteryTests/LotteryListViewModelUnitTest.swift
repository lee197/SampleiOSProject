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
    var userDefaults: UserDefaults!
    
    override func setUpWithError() throws {
        userDefaults = UserDefaults(suiteName: "fake_file")
        userDefaults.removePersistentDomain(forName: "fake_file")
        
        mocks = MockLotteryRepository()
        sut = LotteryListViewModel(apiClient: mocks,
                                   userDefault: userDefaults)
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
    
    func testGetFromLocalStorage() {
        mocks.IsFetchLotteryListSucceeded = true
        userDefaults.set(10, forKey: "totalAmount")
        let expect = XCTestExpectation(description: "get local amount successfully")

        sut.refreshTotalAmount = { amount in
            expect.fulfill()
            XCTAssertEqual(amount, 10)
        }
        
        sut.initListFetch()
        wait(for: [expect], timeout: 1.0)
    }
    
    func testFetchLotteryListFailed() {
        mocks.IsFetchLotteryListSucceeded = false
        let expect = XCTestExpectation(description: "fetch failed")
        sut.showAlertClosure = { alert in
            expect.fulfill()
            XCTAssertEqual(alert!, "Server error, please try again")
        }
        
        sut.initListFetch()
        wait(for: [expect], timeout: 1.0)
    }

}
