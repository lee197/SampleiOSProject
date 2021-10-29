//
//  ViewController.swift
//  lottery
//
//  Created by Jason Lee on 29/10/2021.
//

import UIKit

class LotteryListViewController: UIViewController {
    private lazy var lotteryListViewModel = {
        return LotteryListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
    }
    
    private func initViewModel() {
        lotteryListViewModel.showAlertClosure = { [weak self] message in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.showAlert(alertMessage: message ?? "UNKOWN ERROR")
            }
        }
        
        lotteryListViewModel.initListFetch()
    }
    
    private func showAlert(alertMessage:String) {
        let alert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

