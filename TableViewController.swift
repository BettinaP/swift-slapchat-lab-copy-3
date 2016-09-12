//
//  TableViewController.swift
//  SlapChat
//
//  Created by susan lovaglio on 7/16/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    let store = DataStore.sharedDataStore //have to call reference to our dataSource so create an instance of dataStore.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        store.fetchData()
        self.tableView.reloadData()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        store.fetchData()
        self.tableView.reloadData()
    }
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        store.fetchData()
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.messages.count //have to override because ***...
        //if we were just adding a tableView to viewController, regular func and we'd have to implement delegate & datasource to conform it to tableView behavior within viewController and thus have access to additional tableView methods
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("basicCell", forIndexPath: indexPath)
        
        cell.textLabel!.text = store.messages[indexPath.row].content
        
        return cell
    }
}
