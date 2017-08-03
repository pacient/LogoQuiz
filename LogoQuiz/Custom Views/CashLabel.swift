//
//  CashLabel.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 03/08/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class CashLabel: UILabel {
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