//
//  Reciept.swift
//  ReceiptMe
//
//  Created by Zachary Tipnis on 7/28/16.
//  Copyright © 2016 Zachal LLC. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class Reciept: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    
    func returnImage() -> UIImage {
        return UIImage(data: self.image!)!
    }
    
    func toString() -> String {
        
        return self.title!
    }
    
    override var description: String {
        
        return self.title!
        
    }
    
}
