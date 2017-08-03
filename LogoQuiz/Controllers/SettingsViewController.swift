//
//  SettingsViewController.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 29/07/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class SettingsViewController: MasterViewController {
    @IBOutlet weak var stackview: UIStackView!
    @IBOutlet weak var blueBar: BlueNavBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateCashText), name: Notifications.updateCash, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCashText()
        stackview.bounds.origin.x -= self.view.bounds.width
    }
    
    @objc func updateCashText() {
        blueBar.cashLabel?.text = UserManager.cashString
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.stackview.bounds.origin.x += self.view.bounds.width
        }, completion: nil)
    }
    @IBAction func resetGamePressed(_ sender: Any) {
        self.present(UserManager.resetProgressAlert(), animated: true, completion: nil)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
