//
//  LotteryDetailModel.swift
//  lottery
//
//  Created by Jason Lee on 29/10/2021.
//

import Foundation

// MARK: - LotteryDetailModel
struct LotteryDetailModel: Codable {
    let id: Int
    let numbers: [Int]
}
