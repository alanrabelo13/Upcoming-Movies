//
//  Images+CoreDataProperties.swift
//  Upcoming Movies
//
//  Created by Alan Rabelo Martins on 09/01/2018.
//  Copyright © 2018 Alan Rabelo Martins. All rights reserved.
//
//

import Foundation
import CoreData


extension Images {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Images> {
        return NSFetchRequest<Images>(entityName: "Images")
    }

    @NSManaged public var backdrop_path: String?
    @NSManaged public var movieID: Int32
    @NSManaged public var poster_path: String?

}
