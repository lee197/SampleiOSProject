//
//  ViewModel.swift
//  lottery
//
//  Created by Jason Lee on 29/10/2021.
//

import Foundation

enum UserAlertError:  String, Error {
    case networkError = "Please check your network and re-launch the app"
    case serverError = "Server error, please try again"
    case unknownError = "Unknow error"
}

class LotteryListViewModel {
    var showAlertClosure: ((_ alertMessage: String?)->())?
    var reloadTableViewClosure: ((_ cellViewModels: [Int])->())?
    var refreshTotalAmount: ((_ amount: Int)->())?
    var LotteryNnumbers: [Int] = [] {
        didSet {
            reloadTableViewClosure?(LotteryNnumbers)
        }
    }
    
    var totalAmount: Int = 0 {
        didSet {
            refreshTotalAmount?(totalAmount)
        }
    }
    
    private let apiClient: LotteryInfoFetchable
    private let userDefault: UserDefaults
    private var alertMessage: String? {
        didSet {
            showAlertClosure?(alertMessage)
        }
    }
    
    init(apiClient:LotteryInfoFetchable = LotteryRepository(),
         userDefault: UserDefaults = UserDefaults.standard) {
        self.apiClient = apiClient
        self.userDefault = userDefault
    }
    
    func initListFetch() {
        apiClient.fetchLotteryList { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let lotteries):
                self.LotteryNnumbers = lotteries.tickets.map{ $0.id }
                self.totalAmount = self.userDefault.integer(forKey: "totalAmount")
            case .failure(_ ):
                self.alertMessage = UserAlertError.serverError.rawValue
            }
        }
    }
    
    func updateTotalAmount() {
        self.totalAmount = self.userDefault.integer(forKey: "totalAmount")
    }
}
