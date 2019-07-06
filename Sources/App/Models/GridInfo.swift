//
//  PCInfoDetailByUsage.swift
//  App
//
//  Created by Reed on 2019/7/5.
//

import Foundation
import FluentSQLite
import Vapor

struct GridInfo:SQLiteModel {
    var id: Int?
    
    let content:[String]
    
    let isTitle:Bool
    
}


/// Allows `Todo` to be used as a dynamic migration.
extension GridInfo: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension GridInfo: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension GridInfo: Parameter { }
