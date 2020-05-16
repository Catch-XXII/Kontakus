//
//  SearchHelper.swift
//  Kontakus
//
//  Created by Cüneyd on 13.01.2020.
//  Copyright © 2020 com.kontakus.www. All rights reserved.
//

import UIKit

public protocol SearchBarDropDown : NSObjectProtocol {
    func dropDown()
}

public protocol ViewGenerator : NSObjectProtocol {
    func viewGenerator()
}

public protocol Animation : NSObjectProtocol {
    func animateWholeScreen()
    func timerFired(index: Int)
    func moveIn(index: Int, completion:@escaping ()-> Void)
    func moveOut(index: Int, completion:@escaping ()-> Void)
}

public protocol FetchAndSave : NSObjectProtocol {
    func fetchContacts()
}

public protocol RandomAvatar : NSObjectProtocol {
    func randomAvatar() -> Data?
}
