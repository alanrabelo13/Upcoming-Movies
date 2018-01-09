//
//  Movies+CoreDataProperties.swift
//  Upcoming Movies
//
//  Created by Alan Rabelo Martins on 09/01/2018.
//  Copyright © 2018 Alan Rabelo Martins. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

extension Movies : CoreDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movies> {
        return NSFetchRequest<Movies>(entityName: "Movies")
    }

    @NSManaged public var id: Int32
    @NSManaged public var original_title: String?
    @NSManaged public var release_date: NSDate?
    @NSManaged public var genres: String?
    
}
