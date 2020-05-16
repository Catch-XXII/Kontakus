//
//  DataBaseOperations.swift
//  Kontakus
//
//  Created by Cüneyd on 8.08.2019.
//
import Foundation
import CoreData
import Contacts

final class DatabaseOperations
{
    private static var sharedDatabaseOperations: DatabaseOperations = {
        let databaseOperations = DatabaseOperations.init()
        return databaseOperations
    }()
    
    class func shared() -> DatabaseOperations {
        return sharedDatabaseOperations
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Kontakus")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func getById(identifier: String) -> PersonEntity? {
        let request: NSFetchRequest<PersonEntity> = PersonEntity.fetchRequest()
        request.predicate = NSPredicate(format: "identifier = %@", identifier)
        var idArray: [PersonEntity]?
        
        do {
            idArray = try self.persistentContainer.viewContext.fetch(request)
        }
        catch {
            print("Error while fetching \(error)")
        }
        
        if idArray!.count > 0 {
            return idArray![0]
        }
        else {
            return nil
        }
    }
        
    func getMaxPoint() -> (Float,Float) {
        
        let request: NSFetchRequest<PersonEntity> = PersonEntity.fetchRequest()
        
        var pointArray: [PersonEntity]?
        
        do {
            pointArray = try self.persistentContainer.viewContext.fetch(request)
        }
        catch {
            print("Error while fetching \(error)")
        }
        
        var maxX = Float(0)
        var maxY = Float(0)
        var prevMaxY = Float(0)
        
        for contact in pointArray! {
            if maxY <= contact.centerY {
                maxY = contact.centerY
                
                if prevMaxY == maxY {
                    if maxX < contact.centerX {
                        maxX = contact.centerX
                    }
                }
                else if prevMaxY < maxY {
                    maxX = contact.centerX
                }
                prevMaxY = contact.centerY
            }
        }
        maxX += 110
        
        if maxX > 220 {
            maxX = 0
            maxY += 120
        }
        return (maxX,maxY)
    }
    
    //MARK:- Create new person from CNContact object
    func createPerson(contact: CNContact) -> PersonEntity {
        
        var newPerson = getById(identifier: contact.identifier)
        
        if newPerson == nil {
            
            newPerson = PersonEntity(context: self.persistentContainer.viewContext)
            
            let date = Date()
            
            let format = DateFormatter()
            
            format.dateFormat = "yyyy/MM/dd HH:mm:ss.SSSS"
            
            let formattedDate = format.string(from: date)
            
            newPerson!.dateCreated = formattedDate
            
            if !AppDelegate.launchedBefore
            {
                let result:(Float,Float) = getMaxPoint()
                newPerson!.centerX = result.0
                newPerson!.centerY = result.1
            }
        }
        
        let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? "No Name"
        
        newPerson!.identifier = contact.identifier
        
        newPerson!.name = fullName
        
        if contact.phoneNumbers.count == 3 {
            let phone1 = (contact.phoneNumbers[0].value).value(forKey: "digits") as! String
            newPerson?.phone1 = phone1
            
            let phone2 = (contact.phoneNumbers[1].value).value(forKey: "digits") as! String
            newPerson?.phone2 = phone2
            
            let phone3 = (contact.phoneNumbers[2].value).value(forKey: "digits") as! String
            newPerson?.phone3 = phone3
        }
            
        else if contact.phoneNumbers.count == 2 {
            let phone1 = (contact.phoneNumbers[0].value).value(forKey: "digits") as! String
            newPerson?.phone1 = phone1
            
            let phone2 = (contact.phoneNumbers[1].value).value(forKey: "digits") as! String
            newPerson?.phone2 = phone2
        }
            
        else if contact.phoneNumbers.count == 1 {
            let phone1 = (contact.phoneNumbers[0].value).value(forKey: "digits") as! String
            newPerson?.phone1 = phone1
        }
        
        if contact.imageDataAvailable {
            guard let data = contact.imageData else { return newPerson!}
            if newPerson!.imageData == nil {
                newPerson!.imageData = data
            }
        }
        
        for email:CNLabeledValue in contact.emailAddresses {
            newPerson!.email = email.value as String?
        }
        return newPerson!
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            }
            catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


