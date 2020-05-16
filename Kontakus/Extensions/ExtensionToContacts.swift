//
//  ExtensionToDatabase.swift
//  Kontakus
//
//  Created by Cüneyd on 13.01.2020.
//  Copyright © 2020 com.kontakus.www. All rights reserved.
//

import UIKit
import Contacts

extension MainViewController: FetchAndSave {
    //MARK:- Fetch all contacts with request access.
    internal func fetchContacts() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in guard granted else {
            let alert = UIAlertController(title: "Kontakus", message: "Allow Kontakus to access: Contacts", preferredStyle: .alert)
            
            func openSettings(alert: UIAlertAction!) {
                if let url = URL.init(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: openSettings(alert:)))
            self.present(alert, animated:true, completion: nil)
            return }
            
            let parameters = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                              CNContactPhoneNumbersKey,
                              CNContactEmailAddressesKey,
                              CNContactImageDataKey,
                              CNContactImageDataAvailableKey] as [Any]
            
            let request = CNContactFetchRequest(keysToFetch: parameters as! [CNKeyDescriptor])
            
            request.sortOrder = CNContactSortOrder.userDefault
            
            try! store.enumerateContacts(with: request, usingBlock: {
                (contact, stop) in
                let newPerson = DatabaseOperations.shared().createPerson(contact: contact)
                self.nameArray.append(newPerson.name!)
                self.personArray.append(newPerson)
            })
            // Main Thread Checker - Dispatch the call to update the scrollView to the main thread
            DispatchQueue.main.async {
                self.googleAdSetup()
                self.scrollViewSetup(count: self.personArray.count)
            }
            
            if AppDelegate.launchedBefore {
                self.positionCalculator(count: self.personArray.count)
                DispatchQueue.main.asyncAfter(deadline: .now(), qos: .background, flags: .noQoS) {
                    self.viewGenerator()
                }
            }
            else {
                UserDefaults.standard.set(true, forKey: "launchedBefore")
                DispatchQueue.main.asyncAfter(deadline: .now(), qos: .background, flags: .noQoS) {
                    self.viewGenerator()
                }
            }
        }
        DatabaseOperations.shared().saveContext()
    }
}
