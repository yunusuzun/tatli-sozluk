//
//  Extension+UIView.swift
//  TatliSozluk
//
//  Created by Yunus Uzun on 12.05.2020.
//  Copyright © 2020 yunus. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func klavyeAyarla() {
        NotificationCenter.default.addObserver(self, selector: #selector(klavyeKonumayarla(_ :)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func klavyeKonumayarla(_ notification: NSNotification) {
        let sure = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let baslangicFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let bitisFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let fark = bitisFrame.origin.y - baslangicFrame.origin.y
        
        UIView.animateKeyframes(withDuration: sure, delay: 0.0, options: UIView.KeyframeAnimationOptions.init(rawValue: curve), animations: {
            self.frame.origin.y += fark
        }, completion: nil)
    }
}
