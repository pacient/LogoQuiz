//
//  CashLabel.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 03/08/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class CashLabel: UILabel {
    
    private var token: NSKeyValueObservation!
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(cashLabelTapped))
        addGestureRecognizer(tap)
        setTextValue(value: CashManager.instance.cash)
        token = CashManager.instance.observe(\.cash) { [weak self] (manager, _) in
            DispatchQueue.main.async {
                if let oldValue = manager.oldCash {
                    self?.count(from: oldValue, to: manager.cash)
                }else {
                    self?.setTextValue(value: manager.cash)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        token = nil
    }
    
    //TODO: Implement me
    @objc func cashLabelTapped() {
        //here we are going to present a small alert like view with all our in-app purchases
        guard CashProducts.store.allProducts.count > 0 else {
            let alert = UIAlertController(title: "Oops!", message: "Something went wrong. Please try again later.", style: .alert, cancelText: "OK")
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: false, completion: nil)
            return
        }
        let vc = UIStoryboard(name: "Products", bundle: nil).instantiateInitialViewController()!
        vc.modalPresentationStyle = .overCurrentContext
        
        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: false, completion: nil)
    }
    
    var animationDuration = 30.0
    
    fileprivate var startingValue = 0
    fileprivate var destinationValue = 0
    fileprivate var progress = 0.0
    fileprivate var totalTime = 0.0
    fileprivate var easingRate = 0
    fileprivate var timer: Timer?
    fileprivate var rate: Float = 0.0
    fileprivate var lastUpdate: TimeInterval = 0
    
    
    fileprivate var currentValue: Int {
        if progress >= totalTime { return destinationValue }
        return startingValue + Int((update(t: Float(progress/totalTime)) * Float(destinationValue - startingValue)))
    }
    
    func count(from: Int, to: Int) {
        startingValue = from
        destinationValue = to
        timer?.invalidate()
        timer = nil
        
        easingRate = 3
        progress = 0
        totalTime = animationDuration
        lastUpdate = Date.timeIntervalSinceReferenceDate
        rate = 3.0
        
        addTimer()
        if from >= to {
            shrink()
        }else {
            enlarge()
        }
    }
    
    fileprivate func update(t: Float) -> Float {
        var t = t
        var sign: Float = 1
        if Int(rate) % 2 == 0 { sign = -1}
        t *= 2
        return t < 1 ? 0.5 * powf(t, rate) : (sign*0.5) * (powf(t-2, rate) + sign*2)
    }
    
    fileprivate func addTimer() {
        timer = Timer(timeInterval: 0.01, target: self, selector: #selector(updateValue(timer:)), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .defaultRunLoopMode)
        RunLoop.current.add(timer!, forMode: .UITrackingRunLoopMode)
    }
    
    @objc fileprivate func updateValue(timer: Timer) {
        let now: TimeInterval = Date.timeIntervalSinceReferenceDate
        progress += now - lastUpdate
        
        if progress >= totalTime {
            self.timer?.invalidate()
            self.timer = nil
            progress = totalTime
        }
        
        setTextValue(value: currentValue)
    }
    
    fileprivate func setTextValue(value: Int) {
        text = "💵\(value)"
    }
}
