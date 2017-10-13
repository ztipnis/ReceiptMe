//
//  Reciept+CoreDataProperties.swift
//  ReceiptMe
//
//  Created by Zachary Tipnis on 7/29/16.
//  Copyright © 2016 Zachal LLC. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Reciept {

    @NSManaged var image: NSData?
    @NSManaged var text: String?
    @NSManaged var title: String?
    @NSManaged var date: NSDate?

}
