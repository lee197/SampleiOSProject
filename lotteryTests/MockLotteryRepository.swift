//
//  MockLotteryRepository.swift
//  lotteryTests
//
//  Created by Jason Lee on 29/10/2021.
//

import Foundation
@testable import lottery

class MockLotteryRepository: LotteryInfoFetchable {
    var IsFetchLotteryListSucceeded = false
    var IsFetchLotteryResultSucceeded = false
    
    func fetchLotteryList(complete completionHandler: @escaping (Result<LotteryListAPIModel, APIError>) -> Void) {
        if IsFetchLotteryListSucceeded {
            completionHandler(.success(MockLotteryListAPIModel().generateLotteryList()))
        } else {
            completionHandler(.failure(APIError.serverError))
        }
    }
    
    func fetchLotteryResults(with ticketNumber: String, complete completionHandler: @escaping (Result<LotteryResultAPIModel, APIError>) -> Void) {
        if IsFetchLotteryResultSucceeded {
            completionHandler(.success(MockLotteryResultAPIModel().generateLotteryResultModel(Int(ticketNumber)!)))
        } else {
            completionHandler(.failure(APIError.serverError))
        }
    }
}

class MockLotteryListAPIModel {
    func generateLotteryList() -> LotteryListAPIModel {
        return LotteryListAPIModel(tickets: [Ticket(id: 1, created: 0),
                                             Ticket(id: 2, created: 0),
                                             Ticket(id: 3, created: 0),
                                             Ticket(id: 4, created: 0),
                                             Ticket(id: 5, created: 0)])
    }
}

class MockLotteryResultAPIModel {
    func generateLotteryResultModel(_ ticketNumber: Int) -> LotteryResultAPIModel {
        switch ticketNumber {
        case 1:
            return LotteryResultAPIModel(id: ticketNumber, numbers: MockNumbers().tenEuroLottery())
        case 2:
            return LotteryResultAPIModel(id: ticketNumber, numbers: MockNumbers().fiveEuroLottery())
        case 3:
            return LotteryResultAPIModel(id: ticketNumber, numbers: MockNumbers().zeroLottery())
        case 4:
            return LotteryResultAPIModel(id: ticketNumber, numbers: MockNumbers().oneEuroLottery())
        case 5:
            return LotteryResultAPIModel(id: ticketNumber, numbers: MockNumbers().corruptDataLottery())
        default:
            return LotteryResultAPIModel(id: ticketNumber, numbers: MockNumbers().corruptDataLottery())
        }
    }
}

class MockNumbers {
    
    func fiveEuroLottery() -> [Int] {
        return [1,1,1]
    }
    
    func tenEuroLottery() -> [Int] {
        return [1,1,0]
    }
    
    func oneEuroLottery() -> [Int] {
        return [2,1,0]
    }
    
    func zeroLottery() -> [Int] {
        return [1,1,2]
    }
    
    func corruptDataLottery() -> [Int] {
        return [1,1]
    }
}
