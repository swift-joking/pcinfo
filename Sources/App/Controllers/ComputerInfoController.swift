//
//  ComputerInfoController.swift
//  App
//
//  Created by Reed on 2019/7/5.
//

import Foundation
import SwiftSoup
import Vapor


let websiteDomain = "http://www.lotpc.com"

final class ComputerInfoController:RouteCollection {
    
    func boot(router: Router) throws {
        
        let group =  router.grouped("info")
        
        group.get("banners", use: getBannerInfo)
        group.get("list",Int.parameter, use: getInfoList)
        group.get("detail", use: getInfoDetail)
    }
    
}

// list
extension ComputerInfoController{
    
    
    private func getBannerInfo(_ req:Request) throws -> Future<Response>{
        
        var bannerDicts = [[String:String]]()
        do {
            
            let path = websiteDomain
            let url = URL(string: path)!

            let html = try String(contentsOf: url)
            let doc:Document = try SwiftSoup.parse(html)

            let baaners = try doc.select("li[class='xtaber-item']")
            
            for li in baaners {
                var imagePath = try li.select("img").attr("src")
                imagePath = websiteDomain + imagePath
                
                let title = try li.select("strong").text()
                
                bannerDicts.append(["imagePath":imagePath,"title":title])
                
            }
            
        } catch   {
            
            print("error")
        }
        
        if bannerDicts.isEmpty {
            return try ResponseJSON<Empty>(status: .ok,message: "暂时没有更多资讯!").encode(for: req)
        }
        
        return try ResponseJSON<[[String:String]]>(data: bannerDicts).encode(for: req)

        
    }

    
    private func getInfoList(_ req: Request) throws -> Future<Response>{
        
        let page = try req.parameters.next(Int.self)
        
        let path = websiteDomain + "/diynews/" + (page > 0 ? "32_\(page).html":"")
        
        let url = URL(string: path)!
        
        var newsArray = [News]()

        do {
            
            
            let html = try String(contentsOf: url)
            let doc:Document = try SwiftSoup.parse(html)
            let list = try doc.select("ul[class='pic-list']").select("div[class='li-main']")
            
            
            try list.enumerated().forEach { ( index, div) in
                
                let title = try div.select("strong[class='h3']").select("a").text()
                let desc = try div.select("p[class='ext']").text()
                var image = try div.select("img").attr("src")
                image = websiteDomain + image
                var time = try div.select("p[class='ext']").select("span").text()
                time = time.components(separatedBy: " ").first!
                let detailPath = try div.select("p[class='ext']").select("a").attr("href")
                
                print("title:\(title)\n image:\(image)\n detail:\(detailPath) \n desc:\(desc) \n time:\(time)")
                
                let news = News(id: index, cover: image, title: title, desc: desc,time:time,detailPath:detailPath,price: nil)
                
                newsArray.append(news)
            }
            
            
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }

        if newsArray.isEmpty {
            return try ResponseJSON<Empty>(status: .ok,message: "暂时没有更多资讯!").encode(for: req)
        }
        
        return try ResponseJSON<[News]>(data: newsArray).encode(for: req)
    }
}


// detail
extension ComputerInfoController{
    
    private func getInfoDetail(_ req:Request) throws -> Future<Response>{

        
        var path = try req.query.get(String.self, at: "path")
        path = websiteDomain + path

        let url = URL(string: path)!
        
        
        
        var detail:NewsDetail?
        
        do {
            
            
            let html = try String(contentsOf: url)
            let doc:Document = try SwiftSoup.parse(html)
            
            let topDiv = try doc.select("div[class='art-top']")

            let title = try topDiv.select("h1").text()
            let titleSubInfo = try topDiv.select("div[class='ext']").text()
            let time = titleSubInfo.components(separatedBy: "编辑").first?.components(separatedBy: "时间：").last ?? ""
            let editor = titleSubInfo.components(separatedBy: "围观次数").first?.components(separatedBy: "编辑：").last?.trimmingCharacters(in: .whitespaces) ?? ""
            
            
            let bodyTable = try doc.select("td[class='article_body_td']")
            let pList = try bodyTable.select("p")
            
            var contentArray = [DetailConentInfo]()
            
            try pList.enumerated().forEach({ (index,p) in

                
                if let image = try p.select("img").first(){
                    
                    var imagePath =  try image.attr("src")
                    imagePath = websiteDomain + imagePath
                    contentArray.append(DetailConentInfo(id: index, content: imagePath, isImage: true))
                    
                }else{
                    
                    let text = try p.text()
                    contentArray.append(DetailConentInfo(id: index, content: text, isImage: false))
                }
            })
            
            detail = NewsDetail(id: nil, title: title, time: time, editor: editor, contentArray: contentArray,grids: nil)
        
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
            
        }
        

        guard  let unwrapDetail = detail else {
            return try ResponseJSON<Empty>(status: .ok,message: "未找到该内容").encode(for: req)
        }
        
        return try ResponseJSON<NewsDetail>(data: unwrapDetail).encode(for: req)

    }
}

