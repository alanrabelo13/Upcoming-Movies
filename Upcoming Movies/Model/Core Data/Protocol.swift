//
//  Protocol.swift
//  Upcoming Movies
//
//  Created by Alan Rabelo Martins on 09/01/2018.
//  Copyright © 2018 Alan Rabelo Martins. All rights reserved.
//
import Foundation

public protocol Writeable {
    
    func save()
}

public protocol Deletable {
    
    func destroy()
}

public protocol Readeable {
    
    static func all() -> [Self]
    
    static func find(_ predicate: NSPredicate) -> [Self]
    
}



public protocol ModelType: ActiveRecordType {
    
    associatedtype Context
    
    static var context: Self.Context {get}
    
}
