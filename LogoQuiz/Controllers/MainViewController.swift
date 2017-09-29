//
//  MainViewController.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 29/07/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class MainViewController: MasterViewController {
    @IBOutlet weak var blueBar: BlueNavBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate func presentCongratsAlert() {
        let alert = UserManager.congratulationsAlert()
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func playPressed(_ sender: Any) {
        let stagesVC = UIStoryboard(name: "Stages", bundle: nil).instantiateInitialViewController()!
        navigationController?.pushViewController(stagesVC, animated: true)
    }
    
    @IBAction func resetProgressPressed(_ sender: Any) {
        self.present(UserManager.resetProgressAlert(), animated: true, completion: nil)
    }
    
    @IBAction func settingsPressed(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settingsVC")
        navigationController?.pushViewController(vc, animated: true)
    }
}
