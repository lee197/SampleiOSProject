//
//  LotteryCalculatorUnitTest.swift
//  lotteryTests
//
//  Created by Jason Lee on 29/10/2021.
//

import XCTest
@testable import lottery

class LotteryCalculatorUnitTest: XCTestCase {
    var sut: LotteryCalculator!
    var mocks: MockNumbers!
    
    override func setUpWithError() throws {
        sut = LotteryCalculator()
        mocks = MockNumbers()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mocks = nil
    }
    
    func testFiveEuroLottery() {
        let result = try? sut.findLotteryAmount(numbers: mocks.fiveEuroLottery())
        XCTAssertNotNil(result)
        XCTAssertEqual(result, 5)
    }
    
    func testTenEuroLottery() {
        let result = try? sut.findLotteryAmount(numbers: mocks.tenEuroLottery())
        XCTAssertNotNil(result)
        XCTAssertEqual(result, 10)
    }
    
    func testOneEuroLottery() {
        let result = try? sut.findLotteryAmount(numbers: mocks.oneEuroLottery())
        XCTAssertNotNil(result)
        XCTAssertEqual(result, 1)
    }
    
    func testZeroEuroLottery() {
        let result = try? sut.findLotteryAmount(numbers: mocks.zeroLottery())
        XCTAssertNotNil(result)
        XCTAssertEqual(result, 0)
    }
    
    func testCorruptDataLottery() {
        XCTAssertThrowsError(try sut.findLotteryAmount(numbers: mocks.corruptDataLottery())) { error in
            XCTAssertEqual(error as? LotteryRuleError, LotteryRuleError.valuesCountError)
        }
    }
}
