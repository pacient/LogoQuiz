//
//  MainViewController.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 29/07/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class MainViewController: MasterViewController {
    
    @IBAction func playPressed(_ sender: Any) {
        let playVC = UIStoryboard(name: "PlayScene", bundle: nil).instantiateInitialViewController()!
        navigationController?.pushViewController(playVC, animated: true)
    }
    
    @IBAction func resetProgressPressed(_ sender: Any) {
    }
    
    @IBAction func settingsPressed(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settingsVC")
        navigationController?.pushViewController(vc, animated: true)
    }
}
