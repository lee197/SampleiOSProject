//
//  LotteryResultViewModel.swift
//  lottery
//
//  Created by Jason Lee on 29/10/2021.
//

import Foundation

class LotteryResultViewModel {
    var showAlertClosure: ((_ alertMessage: String?)->())?
    var updateResultViewClosure: ((_ lotteryResultModel: LotteryResultModel?)->())?
    var ticketNumber: Int?
    private let apiClient: LotteryInfoFetchable
    private let lotteryCalculator: LotteryCalculatorProtocol
    private let userDefault: UserDefaults

    private var alertMessage: String? {
        didSet {
            showAlertClosure?(alertMessage)
        }
    }
    private var lotteryResultModel: LotteryResultModel? {
        didSet {
            updateResultViewClosure?(lotteryResultModel)
        }
    }

    init(apiClient:LotteryInfoFetchable = LotteryRepository(),
         lotteryCalculator: LotteryCalculatorProtocol = LotteryCalculator(),
         userDefault: UserDefaults = UserDefaults.standard) {
        self.apiClient = apiClient
        self.lotteryCalculator = lotteryCalculator
        self.userDefault = userDefault
    }
    
    func initResultFetch(ticketNumber: String) {
        apiClient.fetchLotteryResults(with: ticketNumber) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let lottery):
                do {
                    let value = try self.lotteryCalculator.findLotteryAmount(numbers: lottery.numbers)
                    let oldTotal = self.userDefault.integer(forKey: "totalAmount")
                    self.userDefault.set(oldTotal + value, forKey: "totalAmount")
                    self.lotteryResultModel = LotteryResultModel(id: lottery.id, result: String(value))
                } catch {
                    self.alertMessage = UserAlertError.unknownError.rawValue
                }
            case .failure(_ ):
                self.alertMessage = UserAlertError.serverError.rawValue
            }
        }
    }
}
