//
//  kontakTheme.swift
//  kontakus
//
//  Created by Cüneyd on 12.07.2019.
//  Copyright © 2019 J8R. All rights reserved.
//

import UIKit

extension UIColor {
    static let kontakBlue = UIColor(red: 66/255, green: 135/255, blue: 245/255, alpha: 1.0)
    static let candyGreen = UIColor(red: 67.0/255.0, green: 205.0/255.0, blue: 135.0/255.0, alpha: 1.0)
}

extension String {
    static let avatarArray: [String] = ["dog","ox","zebra","panda","pelican","rabbit","coala","bear","octapus"]
        
    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    }
    
    func isValid(regex: RegularExpressions) -> Bool {
        return isValid(regex: regex.rawValue)
    }
    func isValid(regex: String) -> Bool {
        return range(of: regex, options: .regularExpression) != nil
    }

    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter { CharacterSet.decimalDigits.contains($0) }
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
    
    func phoneCall() {
        guard isValid(regex: .phone),
        let url = URL(string: "tel://\(self.onlyDigits())"),
        UIApplication.shared.canOpenURL(url) else { return }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func whatsApp() {
        guard isValid(regex: .phone),
        let url = URL(string: "https://api.whatsapp.com/send?phone=\(self.onlyDigits())"),
        UIApplication.shared.canOpenURL(url) else { return }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func faceTime() {
        guard isValid(regex: .phone),
        let url = URL(string: "facetime://\(self.onlyDigits())"),
        UIApplication.shared.canOpenURL(url) else { return }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func send(anEmailTo: String) {
        guard let url = URL(string: "mailto:\(anEmailTo)"),
        UIApplication.shared.canOpenURL(url) else { return }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}


