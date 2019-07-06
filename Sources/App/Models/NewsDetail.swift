//
//  NewsDetail.swift
//  App
//
//  Created by Reed on 2019/7/5.
//

import Foundation
import FluentSQLite
import Vapor

struct NewsDetail:SQLiteModel {
    var id: Int?
    
    let title:String
    
    let time:String
    
    let editor:String
        
    let contentArray:[DetailConentInfo]
    
    let grids:[GridInfo]?
    
}


/// Allows `Todo` to be used as a dynamic migration.
extension NewsDetail: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension NewsDetail: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension NewsDetail: Parameter { }
