//
//  PCInfoDetailByUsage.swift
//  App
//
//  Created by Reed on 2019/7/5.
//

import Foundation
import FluentSQLite
import Vapor

struct CategoryListInfoDetail:SQLiteModel {
    var id: Int?
    
    let title:String
    
    let time:String
    
    let editor:String
    
    let contentArray:[[Int:String]]
    
    let
    
}


/// Allows `Todo` to be used as a dynamic migration.
extension CategoryListInfoDetail: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension CategoryListInfoDetail: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension CategoryListInfoDetail: Parameter { }
