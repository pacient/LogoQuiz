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
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCashText), name: Notifications.updateCash, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateCashText()
    }
    
    @objc func updateCashText() {
        blueBar.cashLabel?.text = UserManager.cashString
    }
    
    fileprivate func presentCongratsAlert() {
        let alert = UserManager.congratulationsAlert()
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func playPressed(_ sender: Any) {
        guard let brand = UserManager.brandToFind else {
            presentCongratsAlert()
            return
        }
        let playVC = UIStoryboard(name: "PlayScene", bundle: nil).instantiateInitialViewController() as! PlaySceneViewController
        playVC.brandViewModel = BrandViewModel(brand: brand)
        navigationController?.pushViewController(playVC, animated: true)
    }
    
    @IBAction func resetProgressPressed(_ sender: Any) {
        self.present(UserManager.resetProgressAlert(), animated: true, completion: nil)
    }
    
    @IBAction func settingsPressed(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settingsVC")
        navigationController?.pushViewController(vc, animated: true)
    }
}
