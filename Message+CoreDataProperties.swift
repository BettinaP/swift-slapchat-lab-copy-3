//
//  Message+CoreDataProperties.swift
//  SlapChat
//
//  Created by Bettina on 9/12/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Message {

    @NSManaged var createdAt: NSDate?
    @NSManaged var content: String?

}
