//
//  ViewModel.swift
//  lottery
//
//  Created by Jason Lee on 29/10/2021.
//

import Foundation

enum UserAlertError:  String, Error {
    case userError = "Please make sure your network is working fine or re-launch the app"
    case serverError = "Please wait a while and re-launch the app"
}

class LotteryListViewModel {
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
    
    func initListFetch() {
        apiClient.fetchLotteryList { [weak self] result in
            guard let self = self else { return }
            do {
                let interests = try result.get()
            
            } catch {
                self.alertMessage = UserAlertError.serverError.rawValue
            }
        }
    }
    
    func initDetailFetch() {
        apiClient.fetchLotteryDetails(ticketNumber: "1") { [weak self] result in
            guard let self = self else { return }
            do {
                let interests = try result.get()
            
            } catch {
                self.alertMessage = UserAlertError.serverError.rawValue
            }
        }
    }
}
