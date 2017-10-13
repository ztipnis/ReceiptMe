//
//  RecUM.swift
//  ReceiptMe
//
//  Created by Zachary Tipnis on 8/5/16.
//  Copyright © 2016 Zachal LLC. All rights reserved.
//

import Foundation
import UIKit

class unmanagedReciept {
    
    var image: UIImage?
    var text: String?
    var title: String?
    var date: NSDate?
    
    func getUnmanagedFor(reciept: Reciept) {
        self.image = reciept.returnImage()
        self.text = reciept.text
        self.date = reciept.date
        self.title = reciept.toString()
        
    }
    
}