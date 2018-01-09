//
//  Extensions.swift
//  Upcoming Movies
//
//  Created by Alan Rabelo Martins on 08/01/2018.
//  Copyright © 2018 Alan Rabelo Martins. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension UICollectionViewCell {
    func cardenize() {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius:
            self.contentView.layer.cornerRadius).cgPath
        
        self.contentView.layer.cornerRadius = 5.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
    }
}

extension String {
    
    func dateFormatted(withFormat format : String = "yyyy-MM-dd") -> String {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = format
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        let date: Date? = dateFormatterGet.date(from: self)
        
        return dateFormatter.string(from: date!)
        
    }
}

extension NSManagedObject {
    
    static var className: String {
        return String(describing: self)
    }
}
