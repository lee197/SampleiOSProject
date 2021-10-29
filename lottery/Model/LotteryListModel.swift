//
//  LotteryListModel.swift
//  lottery
//
//  Created by Jason Lee on 29/10/2021.
//

import Foundation

// MARK: - LotteryListModel
struct LotteryListModel: Codable {
    let tickets: [Ticket]
}

// MARK: - Ticket
struct Ticket: Codable {
    let id, created: Int
}
