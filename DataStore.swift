//
//  DataStore.swift
//  SlapChat
//
//  Created by susan lovaglio on 7/16/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import CoreData

class DataStore {
    

    static let sharedDataStore = DataStore() // using data file as singleton, and because we created it as a static let, we can call on this specific variable from anywhere in program, with no need to instantiate a version or create an actual instance of dataStore every time ** At any point afterwards, can call dataStore.sharedDataStore as single instance of dataStore from anywhere and be working within same exact objectContext.
    
    var messages = [Message]() //empty array of message, var because we're going to be adding Messages into array
    
    //var messages: [String]
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func fetchData() { //perform a fetch request to fill an array property on your datastore
        
        let messageFetch = NSFetchRequest(entityName: Message.entityName) // created a variable to store entityName of the entity/class "Message" string to reduce chances of error/typos throughout program
            //returns an array of messages, giving back essentially an array of NSManagedObjects since Message entity inherits from NSManagedObject. Thus we must cast as Message so we can receive array of messages.
        
            // didn't need to created a ManagedObjectContext. Managed Object Context property getter. This is where we've dropped our "boilerplate" code.
            // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
            // necessary "boilerplate" code for linking an NSManagedObjectContext to your .xcdatamodeld, and we've thrown it in the getter for our context property. This is good because the context needs to be setup a particular way, and overriding the getter allows us to properly set it up whenever it may need.
    
        let createdAtSort = NSSortDescriptor(key: "createdAt", ascending: true)
        messageFetch.sortDescriptors = [createdAtSort]
            //we can make results better by sorting what we get back from Core Data fetch request from database (especially relational databases) into an array using sort descriptors
        
        
        do {
                //core data forces you to create blocks that will make you deal with potential error, block will throw error that must be handled like: "If you tried to fetch and you didn't get anything back, why didn't you get anything back?" "If you tried to save and it didn't work, why didn't it work? why did that happen?". It won't just let you execute the request--resolve with do, try, catch.
            
            self.messages = try self.managedObjectContext.executeRequest(messageFetch) as! [Message]
                // fetch request is getting us an array of messages, giving back essentially an array of NSManagedObjects since Message entity inherits from NSManagedObject. Thus we must cast as Message so we can receive array of messages.
               // set the results of request to our empty array/stored in it.
            
            
        } catch {
            
            print("Fetch doesn't work")
    
        }
        
        
       if messages.count == 0 { //only generate test data if there's nothing there, don't need it to be created each time
        generateTestData()
        }
    
    }
    
    
    //func fetchData () {
    //perform a fetch request to fill an array property on your datastore
    //let messageFetch = NSFetchRequest(entityName: message.entityName)//"Message")
             //returns array of messages, giving back NSmanageObject, but we know message inherits from it so just give me an aray of messages.
       // let createdAtSort = NSSortDescriptor(key:"createdAt", ascending:true)
        //messageFetch.sortDescriptors = [createdAtSort]
        
        //do {
          //  self.messages = try self.managedObjectContext.executeFetchRequest(messageFetch)  as! [messages]//***
        
       // } catch {
            //print("fetch doesn't work")
        
        //}
        
        //if messages.count == 0{ //only generate data if there's nothing there, don't need it to be created each time
           // generateTestData()
       // }
    //}
    
    
    
    func generateTestData(){
    
        let message1 = NSEntityDescription.insertNewObjectForEntityForName(Message.entityName, inManagedObjectContext: self.managedObjectContext) as! Message
            // NSEntityDescription is a class
            // check all your files, static string allows you to call ** saves you from chance of having an error later on
            //cast message1 as a message though because it's a managedObject?, thus force it to get the type of what you want and so you can access the entity's properties. It's ok to force unwrap UI stuff and CoreData items. For Core Data because you know your entity subclasses from NSManagedObject and you know you're putting something in that you know they'll be the same or there's a relationship between the two
        message1.content = "johann"
        message1.createdAt = NSDate()
    
        
        let message2 = NSEntityDescription.insertNewObjectForEntityForName(Message.entityName, inManagedObjectContext: self.managedObjectContext) as! Message
        message2.content = "susan"
        message2.createdAt = NSDate()
        
        
        let message3 = NSEntityDescription.insertNewObjectForEntityForName(Message.entityName, inManagedObjectContext: self.managedObjectContext) as! Message
        message3.content = "ian"
        message3.createdAt = NSDate()
        
        saveContext()
        fetchData() //adds messages
        //thsi function would make sense to create it in dataStore so you can pull it into variety of places instead of viewController.it'll work both ways but could be in tableViewController
    }
    
    
    // MARK: - Core Data stack
    // Managed Object Context property getter. This is where we've dropped our "boilerplate" code.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application. 
            // necessary "boilerplate" code for linking an NSManagedObjectContext to your .xcdatamodeld, and we've thrown it in the getter for our context property. This is good because the context needs to be setup a particular way, and overriding the getter allows us to properly set it up whenever it may need.

    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Slapchat2Model", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("slapChat.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    //MARK: Application's Documents directory
    // Returns the URL to the application's Documents directory.
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.FlatironSchool.SlapChat" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
}