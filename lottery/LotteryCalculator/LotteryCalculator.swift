//
//  LotteryCalculator.swift
//  lottery
//
//  Created by Jason Lee on 29/10/2021.
//

import Foundation

enum LotteryRuleError: Error {
    case valuesCountError
}

protocol LotteryCalculatorProtocol {
    func findLotteryAmount(numbers: [Int]) throws -> Int
}

class LotteryCalculator: LotteryCalculatorProtocol {
    
    func findLotteryAmount(numbers: [Int]) throws -> Int {
        if numbers.count != 3 {
            throw LotteryRuleError.valuesCountError
        }
        
        if numbers.reduce(0, +) == 2 {
            return 10
        }
        
        if numbers.dropLast().allSatisfy({ $0 == numbers.last }) {
            return 5
        }
        
        if numbers[0] != numbers[1] && numbers[0] != numbers[2] {
            return 1
        }
        
        return 0
    }
}
