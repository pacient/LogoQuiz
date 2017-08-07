//
//  ProductsViewController.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 05/08/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit
import Firebase

enum DataSourceItem {
    case cash
    case ad
}

class ProductsViewController: UIViewController {
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let products = CashProducts.store.allProducts.sorted { (first, second) -> Bool in
        return first.price.floatValue < second.price.floatValue
    }
    
    fileprivate var dataSource = [DataSourceItem]()
    override func viewDidLoad() {
        super.viewDidLoad()
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        GADRewardBasedVideoAd.sharedInstance().load(request, withAdUnitID: "ca-app-pub-9037734016404410/4581503149")
        
        products.forEach({ _ in
            dataSource.append(.cash)
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissVC()
    }
    
    @objc func dismissVC() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.tableViewContainer.frame.origin.y = self.view.frame.height
        }) { (completed) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableViewContainer.frame.origin.y = view.frame.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.tableViewContainer.frame.origin.y -= self.view.frame.height/2 - 20
        }, completion: nil)
    }
}

//MARK: TableView Delegate

extension ProductsViewController:  UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cashProduct") as! ProductCell
        switch dataSource[indexPath.row] {
        case .cash:
            cell.product = self.products[indexPath.row]
        case .ad:
            cell.productName.text = "💵 80 Cash"
            cell.productButton.setTitle("Video", for: .normal)
            cell.isAd = true
            cell.delegate = self
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(dataSource.count) - 10
    }
}

extension ProductsViewController: RewardAdProtocol {
    func presentRewardAd() {
        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }else {
            let alert = UIAlertController(title: "Oops", message: "The ad is not ready yet. Please try again later.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK 😞", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
}

extension ProductsViewController: GADRewardBasedVideoAdDelegate {
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
        print("Reward based video ad failed to load with error: \(error.localizedDescription)")
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad received successfully!")
        dataSource.append(.ad)
        tableView.reloadData()
    }
    
}

