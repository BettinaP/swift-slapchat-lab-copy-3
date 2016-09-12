//
//  AddViewController.swift
//  SlapChat
//
//  Created by Bettina on 9/12/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import CoreData //needs to be imported in each new file

class AddViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    let store = DataStore.sharedDataStore
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func addButtonPressed(sender: AnyObject) {
   
    //add smae thing we inserted, like test messages
        
        
        let message2 = NSEntityDescription.insertNewObjectForEntityForName(Message.entityName, inManagedObjectContext: store.managedObjectContext) as! Message
        message2.content = self.textField.text
        message2.createdAt = NSDate()
    
        store.saveContext()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
