//
//  RewardAdManager.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 07/08/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Firebase

class RewardAdManager: NSObject, GADRewardBasedVideoAdDelegate, RewardAdProtocol {
    static let instance = RewardAdManager()
    private static let adUnitID = "ca-app-pub-9037734016404410/4581503149"
    var isAdLoaded: Bool {
        return GADRewardBasedVideoAd.sharedInstance().isReady
    }
    
    var rootVC: UIViewController?
    
    func loadAd() {
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        GADRewardBasedVideoAd.sharedInstance().load(request, withAdUnitID: RewardAdManager.adUnitID)
    }
    
    //MARK: GADRewardBasedVideoAdDelegate
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        print("Reward Ad Video rewarded user with \(reward.type)\(reward.amount.intValue)")
        CashManager.bumpCash(amount: reward.amount.intValue)
        loadAd()
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward Video Ad has been received successfully!")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
        print("Reward Video Ad failed to load with error: \(error.localizedDescription)")
    }
    
    //MARK: RewardAdProtocol
    func presentRewardAd() {
        guard let rootVC = rootVC else {
            print("No root vc available")
            return
        }
        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: rootVC)
        }else {
            let alert = UIAlertController(title: "Oops", message: "The ad is not ready yet. Please try again later.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK 😞", style: .cancel, handler: nil)
            alert.addAction(action)
            rootVC.present(alert, animated: true, completion: nil)
        }
    }
}
