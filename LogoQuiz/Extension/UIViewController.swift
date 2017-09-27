//
//  UIViewController.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 27/09/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentProducts() {
        guard CashProducts.store.allProducts.count > 0 else {
            let alert = UIAlertController(title: "Oops!", message: "Something went wrong. Please try again later.", style: .alert, cancelText: "OK")
            present(alert, animated: false, completion: nil)
            return
        }
        let vcProducts = UIStoryboard(name: "Products", bundle: nil).instantiateInitialViewController()!
        vcProducts.modalPresentationStyle = .overCurrentContext
        
        present(vcProducts, animated: false, completion: nil)
    }
}
