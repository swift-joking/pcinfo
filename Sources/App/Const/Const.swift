//
//  Const.swift
//  App
//
//  Created by Reed on 2019/7/5.
//

import Foundation
import Vapor
import Fluent

public let CrawlerHeader: HTTPHeaders = ["User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Safari/537.36"
    ,"Cookie": "yunsuo_session_verify=2a87ab507187674302f32bbc33248656"]


//func getHTMLResponse(_ req:Request,url: String) throws -> Future<String> {
//    
//    return try req.client().get(url,headers: CrawlerHeader).map {
//        return $0.utf8String
//    }
//}
