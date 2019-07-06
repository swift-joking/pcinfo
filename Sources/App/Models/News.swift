//
//  News.swift
//  App
//
//  Created by Reed on 2019/7/5.
//

import Foundation
import FluentSQLite
import Vapor

struct News:SQLiteModel {
    var id: Int?
    
    let cover:String
    
    let title:String
    
    let desc:String
    
    let time:String
    
    let detailPath:String
    
    let price:String?
    
}


/// Allows `Todo` to be used as a dynamic migration.
extension News: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension News: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension News: Parameter { }
