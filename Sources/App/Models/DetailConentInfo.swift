//
//  DetailConentInfo.swift
//  App
//
//  Created by 黄继平 on 2019/7/6.
//

import Foundation
import FluentSQLite
import Vapor

struct DetailConentInfo:SQLiteModel {
    var id: Int?
    
    let content:String
    
    let isImage:Bool
    
}


/// Allows `Todo` to be used as a dynamic migration.
extension DetailConentInfo: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension DetailConentInfo: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension DetailConentInfo: Parameter { }
