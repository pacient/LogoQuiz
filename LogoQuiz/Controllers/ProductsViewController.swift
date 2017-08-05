//
//  ProductsViewController.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 05/08/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController {
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let products = CashProducts.store.allProducts.sorted { (first, second) -> Bool in
        return first.price.floatValue < second.price.floatValue
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return CashProducts.store.allProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cashProduct") as! ProductCell
        cell.product = self.products[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(CashProducts.store.allProducts.count) - 10
    }
}
























