//
//  ExtensionToDropDownSearch.swift
//  Kontakus
//
//  Created by Cüneyd on 13.01.2020.
//  Copyright © 2020 com.kontakus.www. All rights reserved.
//

import UIKit

extension MainViewController: SearchBarDropDown {
    //MARK:- Search bar helper with dropdown menu
    func dropDown() {
        dropButton.anchorView = searchController.searchBar
        dropButton.bottomOffset = CGPoint(x: 0, y:(dropButton.anchorView?.plainView.bounds.height)!)
        dropButton.backgroundColor = .white
        dropButton.direction = .bottom
        dropButton.selectionAction = {
            [unowned self] (index: Int, searchedText: String) in
            self.dismissTheKeyboard()
            self.animateWholeScreen()
            
            for i in 0..<self.personArray.count {
                if self.personArray[i].name?.lowercased() == searchedText.lowercased() {
                    if self.index >= 0 {
                        if self.currentTimer != nil {
                            self.currentTimer?.invalidate()
                            self.isTimmerOn = false
                            self.countDown = 10
                        }
                        self.moveOut(index: self.index, completion: {
                            self.index = i
                            self.moveIn(index: i, completion: {
                                if self.isTimmerOn == false {
                                    self.timerFired(index: i)
                                    self.isTimmerOn = true
                                    
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(12)) {
                                    self.moveOut(index: i, completion: {
                                        self.index = -1 } )
                                    self.isTimmerOn = false } } ) } )

                    }
                    else {
                        self.index = i
                        self.moveIn(index: i, completion: {
                            if self.isTimmerOn == false {
                                self.timerFired(index: i)
                                self.isTimmerOn = true }
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(12)) {
                                self.moveOut(index: i, completion: {
                                    self.index = -1 })
                                self.isTimmerOn = false } } ) }
                    break
                }
            }
        }
    }
}


