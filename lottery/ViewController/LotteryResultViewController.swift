//
//  LotteryResultViewController.swift
//  lottery
//
//  Created by Jason Lee on 29/10/2021.
//

import UIKit

class LotteryResultViewController: UIViewController {
    let lotteryResultViewModel = LotteryResultViewModel()
    var ticketNumber: Int?
    let resultLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        setupResultView()
    }
    
    override open var shouldAutorotate: Bool {
       return false
    }

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       return .portrait
    }
    
    private func setupResultView() {
        self.view.backgroundColor = .white

        let numberLabel = UILabel()
        self.view.addSubview(numberLabel)
        numberLabel.backgroundColor = .white
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.textColor = .black
        numberLabel.textAlignment = .center
        numberLabel.font = numberLabel.font.withSize(40)
        NSLayoutConstraint.activate([
            self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: numberLabel.topAnchor, constant: -30),
            self.view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: numberLabel.leadingAnchor),
            self.view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: numberLabel.trailingAnchor),
        ])
        
        if let ticketNumber = ticketNumber {
            numberLabel.text = "Ticket: " + String(ticketNumber)
        } else {
            numberLabel.text = "Unknown"
        }
        
        resultLabel.backgroundColor = .white
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.textColor = .black
        resultLabel.textAlignment = .center
        resultLabel.font = numberLabel.font.withSize(40)
        self.view.addSubview(resultLabel)
        resultLabel.text = "loading"
        NSLayoutConstraint.activate([
            self.view.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: resultLabel.centerXAnchor),
            self.view.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: resultLabel.centerYAnchor),
            self.view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: resultLabel.leadingAnchor),
            self.view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: resultLabel.trailingAnchor),
        ])
    }
    
    private func initViewModel() {
        lotteryResultViewModel.showAlertClosure = { [weak self] message in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.showAlert(alertMessage: message ?? "UNKOWN ERROR")
            }
        }
        
        lotteryResultViewModel.updateResultViewClosure = { info in
            DispatchQueue.main.async { [weak self] in
                guard let self = self, let info = info else { return }
                self.resultLabel.text = "You won: " + "€" + info.result
            }
        }
        
        guard let ticketNumber = ticketNumber else { return }
        lotteryResultViewModel.initResultFetch(ticketNumber: String(ticketNumber))
    }
    
    private func showAlert(alertMessage:String) {
        let alert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: popBack))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func popBack(alert: UIAlertAction!) {
        _ = navigationController?.popViewController(animated: true)
    }
}
