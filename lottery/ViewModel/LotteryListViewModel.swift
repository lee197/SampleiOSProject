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
    case unknownError = "Please try other items"
}

class LotteryListViewModel {
    var showAlertClosure: (()->())?
    var reloadTableViewClosure: (()->())?
    
    private let apiClient: LotteryInfoFetchable
    private var alertMessage: String? {
        didSet {
            showAlertClosure?()
        }
    }
    private var cellViewModels: [Int] = [] {
        didSet {
            reloadTableViewClosure?()
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
                self.cellViewModels = lotteries.tickets.map{ $0.id }
            case .failure(_ ):
                self.alertMessage = UserAlertError.serverError.rawValue
            }
        }
    }
    
    func getNumberOfCells() -> Int {
        return cellViewModels.count
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> Int {
        return cellViewModels[indexPath.row]
    }
}
