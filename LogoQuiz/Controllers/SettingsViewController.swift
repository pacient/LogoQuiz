//
//  SettingsViewController.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 29/07/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: MasterViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var stackview: UIStackView!
    @IBOutlet weak var blueBar: BlueNavBar!
    
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
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["vnunev2@gmail.com"])
        mailComposerVC.setSubject("Logo Quiz Ultimate Feedback!")
        return mailComposerVC
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Button Actions
    //TODO: Change the id to the current game!!!
    @IBAction func rateGamePressed(_ sender: Any) {
        let url = URL(string: "https://itunes.apple.com/us/app/holitime/id1263932027")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else {
            let alert = UIAlertController(title: "Ooops", message: "The app failed to open App Store.", style: .alert, cancelText: "OK")
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func contactUsPressed(_ sender: Any) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func removeAdsPressed(_ sender: Any) {
    }
    
    @IBAction func buyCashPressed(_ sender: Any) {
        guard CashProducts.store.allProducts.count > 0 else {
            let alert = UIAlertController(title: "Oops!", message: "Something went wrong. Please try again later.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: false, completion: nil)
            return
        }
        let vc = UIStoryboard(name: "Products", bundle: nil).instantiateInitialViewController()!
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false, completion: nil)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
