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
    var LotteryNnumbers: [Int] = [] {
        didSet {
            reloadTableViewClosure?(LotteryNnumbers)
        }
    }
    
    private let apiClient: LotteryInfoFetchable
    private var alertMessage: String? {
        didSet {
            showAlertClosure?(alertMessage)
        }
    }

    
    init(apiClient:LotteryInfoFetchable = LotteryRepository()) {
        self.apiClient = apiClient
    }
    
    func initListFetch() {
        apiClient.fetchLotteryList { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let lotteries):
                self.LotteryNnumbers = lotteries.tickets.map{ $0.id }
            case .failure(_ ):
                self.alertMessage = UserAlertError.serverError.rawValue
            }
        }
    }
}
