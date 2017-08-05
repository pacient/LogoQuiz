//
//  CashProducts.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 04/08/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation

public struct CashProducts {
    
    public static let cash1000 = "com.nunev.LogoQuiz.Cash.1000"
    public static let cash3000 = "com.nunev.LogoQuiz.Cash.3000"
    public static let cash15000 = "com.nunev.LogoQuiz.Cash.15000"
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [CashProducts.cash1000, CashProducts.cash3000, CashProducts.cash15000]
    
    public static let store = IAPHelper(productIds: CashProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
