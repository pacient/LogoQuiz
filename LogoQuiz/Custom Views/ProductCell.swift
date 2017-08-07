//
//  ProductCell.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 05/08/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit
import StoreKit
import Firebase

protocol RewardAdProtocol {
    func presentRewardAd()
}

class ProductCell: UITableViewCell {
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productButton: UIButton!
    
    var delegate: RewardAdProtocol?
    
    var product: SKProduct?
    var isAd = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if let product = product {
            self.productName.text = "💵 \(product.localizedTitle)"
            self.productButton.setTitle(product.localizedPrice(), for: .normal)
        }else if isAd {
            delegate = RewardAdManager.instance
        }
    }
    
    @IBAction func buyPressed(_ sender: Any) {
        if let product = product {
            CashProducts.store.buyProduct(product)
        }else if isAd{
            delegate?.presentRewardAd()
        }
    }
    

}
