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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stackview.bounds.origin.x -= self.view.bounds.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.stackview.bounds.origin.x += self.view.bounds.width
        }, completion: nil)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
