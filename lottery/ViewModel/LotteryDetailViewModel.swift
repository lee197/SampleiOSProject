//
//  LotteryDetailViewModel.swift
//  lottery
//
//  Created by Jason Lee on 29/10/2021.
//

import Foundation

class LotteryDetailViewModel {
    var showAlertClosure: (()->())?
    var updateDetailViewClosure: (()->())?
    
    private let apiClient: LotteryInfoFetchable
    private let lotteryCalculator: LotteryCalculatorProtocol
    private var alertMessage: String? {
        didSet {
            showAlertClosure?()
        }
    }
    private var lotteryDetailModel: LotteryDetailModel? {
        didSet {
            updateDetailViewClosure?()
        }
    }


    init(apiClient:LotteryInfoFetchable = LotteryRepository(),
         lotteryCalculator: LotteryCalculatorProtocol = LotteryCalculator()) {
        self.apiClient = apiClient
        self.lotteryCalculator = lotteryCalculator
    }
    
    func initDetailFetch(ticketNumber: String) {
        apiClient.fetchLotteryDetails(with: ticketNumber) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let lottery):
                do {
                    let value = try self.lotteryCalculator.findLotteryAmount(numbers: lottery.numbers)
                    self.lotteryDetailModel = LotteryDetailModel(id: lottery.id, result: String(value))
                } catch {
                    self.alertMessage = UserAlertError.unknownError.rawValue
                }
            case .failure(_ ):
                self.alertMessage = UserAlertError.serverError.rawValue
            }
        }
    }
}
