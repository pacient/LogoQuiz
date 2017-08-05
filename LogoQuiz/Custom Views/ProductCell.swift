//
//  ProductCell.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 05/08/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit
import StoreKit

class ProductCell: UITableViewCell {
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productButton: UIButton!
    
    var product: SKProduct!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        self.productName.text = "💵 \(product.localizedTitle)"
        self.productButton.setTitle(product.localizedPrice(), for: .normal)
    }
    
    @IBAction func buyPressed(_ sender: Any) {
        CashProducts.store.buyProduct(product)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
