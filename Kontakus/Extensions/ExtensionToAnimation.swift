//
//  ExtensionToAnimation.swift
//  Kontakus
//
//  Created by Cüneyd on 13.01.2020.
//  Copyright © 2020 com.kontakus.www. All rights reserved.
//

import UIKit

extension MainViewController: Animation {    
    func animateWholeScreen() {
        UIView.animate(withDuration: 0.5) {
            for view in self.cellArray {
                view.transform = CGAffineTransform(translationX: 0, y: 120)
            }
        }
    }
    
    func timerFired(index: Int) {
        currentTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {
            timer in self.cellArray[index].timeLabel.text = "\(self.countDown)"
            self.countDown -= 1
            if self.countDown < 0 {
                timer.invalidate()
                self.countDown = 10 } } )
    }
    
    func moveIn(index: Int, completion:@escaping ()-> Void) {
        cellArray[index].timeLabel.isHidden = false
        cellArray[index].timeLabel.text = "\(countDown)"
        animateWholeScreen()
        UIView.animate(withDuration: 1, animations:{
            self.cellArray[index].center.x = 170
            self.cellArray[index].center.y = -60
            self.cellArray[index].backgroundColor = .kontakBlue } ) {
            (complete) in DispatchQueue.main.async { completion() }
            
        }
    }
    
    func moveOut(index: Int, completion:@escaping ()-> Void) {
        if self.index == index {
            cellArray[index].timeLabel.isHidden = true
            UIView.animate(withDuration: 1, animations: {
                self.cellArray[index].frame = CGRect(x: CGFloat(self.personArray[index].centerX), y: CGFloat(self.personArray[index].centerY + 120), width: CGFloat(120), height: CGFloat(120))
                self.cellArray[index].backgroundColor = nil
                for view in self.cellArray {
                    view.transform = .identity
                    
                } } ) {
                (complete) in DispatchQueue.main.async { completion() }
                
            } }
    }
}
