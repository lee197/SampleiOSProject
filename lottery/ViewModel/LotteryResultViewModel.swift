//
//  LotteryResultViewModel.swift
//  lottery
//
//  Created by Jason Lee on 29/10/2021.
//

import Foundation

class LotteryResultViewModel {
    // output
    var showAlertClosure: ((_ alertMessage: String)->())?
    var updateResultViewClosure: ((_ lotteryResultModel: LotteryResultModel?)->())?
    private let apiClient: LotteryInfoFetchable
    private let lotteryCalculator: LotteryCalculatorProtocol
    private let userDefault: UserDefaults

    private var alertMessage: String = "" {
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
    // input
    func initResultFetch(ticketNumber: String) {
        apiClient.fetchLotteryResults(with: ticketNumber) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let lottery):
                self.processLotteryResult(lottery)
            case .failure(_ ):
                self.alertMessage = UserAlertError.serverError.description
            }
        }
    }
    
    private func processLotteryResult(_ lottery: LotteryResultAPIModel) {
        do {
            let newValue = try self.lotteryCalculator.findLotteryAmount(numbers: lottery.numbers)
            let oldTotal = self.userDefault.integer(forKey: UserDefaultKey.totalAmount.rawValue)
            self.userDefault.set(oldTotal + newValue, forKey: UserDefaultKey.totalAmount.rawValue)
            self.lotteryResultModel = LotteryResultModel(id: lottery.id, result: String(newValue))
        } catch {
            self.alertMessage = UserAlertError.unknownError.description
        }
    }
}
