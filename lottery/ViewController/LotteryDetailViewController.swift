//
//  LotteryDetailViewController.swift
//  lottery
//
//  Created by Jason Lee on 29/10/2021.
//

import UIKit

class LotteryDetailViewController: UIViewController {
    let lotteryDetailViewModel: LotteryDetailViewModel
    var ticketNumber = 0
    init(lotteryDetailViewModel: LotteryDetailViewModel) {
        self.lotteryDetailViewModel = lotteryDetailViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
