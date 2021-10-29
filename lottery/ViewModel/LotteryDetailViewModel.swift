//
//  LotteryDetailViewModel.swift
//  lottery
//
//  Created by Jason Lee on 29/10/2021.
//

import Foundation

class LotteryDetailViewModel {
    private let apiClient: LotteryInfoFetchable
    var showAlertClosure: (()->())?
    var alertMessage: String? {
        didSet {
            showAlertClosure?()
        }
    }
    
    init(apiClient:LotteryInfoFetchable = LotteryRepository()) {
        self.apiClient = apiClient
    }
    
    func initFetch() {
        apiClient.fetchLotteryDetails { [weak self] result in
            guard let self = self else { return }
            do {
                let interests = try result.get()
            
            } catch {
                self.alertMessage = UserAlertError.serverError.rawValue
            }
        }
    }
}
