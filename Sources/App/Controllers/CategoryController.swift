//
//  CategoryController.swift
//  App
//
//  Created by Reed on 2019/7/5.
//

import Foundation
import SwiftSoup
import Vapor


typealias StringDict = [String:String]
final class CategoryController:RouteCollection{
    
    
    
    func boot(router: Router) throws {
        
        let group = router.grouped("category")
        group.get("info", use: getCategoryBaseInfo)
        group.get("list", use: getCategoryList)
        group.get("detail", use: getInfoDetail)
        
    }
}


// 分类基本信息
extension CategoryController{
    
    private func getCategoryBaseInfo(_ req:Request)throws -> Future<Response>{
        
        var categoryArray = [[String:[StringDict]]]()
        do {
            
            let path = websiteDomain
            let url = URL(string: path)!
            
            let html = try String(contentsOf: url)
            let doc:Document = try SwiftSoup.parse(html)
            
            let categories = try doc.select("div[class='pzdh']").select("dd")
            
            try categories.enumerated().forEach({ (index,dd) in
                
                if index == 1 {
                    
                    let c1 = try parseCategory(key: "平台", dd: dd, doc: doc)
                    categoryArray.append(c1)
                    
                }else if(index == 2){
                    
                    let c2 = try parseCategory(key: "定位", dd: dd, doc: doc)
                    categoryArray.append(c2)

                }else if(index == 3){
                    let c3 = try parseCategory(key: "用途", dd: dd, doc: doc)
                    categoryArray.append(c3)

                }
            })

            
        } catch   {
            
            print("error")
        }

        if categoryArray.isEmpty {
            return try ResponseJSON<Empty>(status: .ok,message: "暂时没有更多资讯!").encode(for: req)
        }
        
        return try ResponseJSON<[[String:[StringDict]]]>(data: categoryArray).encode(for: req)
        

    }
    
    private func parseCategory(key:String,dd:Element,doc:Document) throws -> [String:[StringDict]] {
        
        
        let aTags = try dd.select("a")
        
        var tags = [StringDict]()
        
        for a in aTags {
            let path = try a.attr("href")
            let name = try a.text()
            tags.append(["path":path,"name":name])
        }
        
        return [key:tags]
        
    }
}

// 根据分类获取列表
extension CategoryController {
    
    private func getCategoryList(_ req:Request) throws -> Future<Response>{
        
        let path = try req.query.get(String.self, at: "path")        
        
        
        var newsArray = [News]()

        do {
            
            let url = URL(string: path)!
            
            let html = try String(contentsOf: url)
            let doc:Document = try SwiftSoup.parse(html)
            
            let list = try doc.select("ul[class='pic-list']").select("li").select("div[class='li-main']")

            try list.enumerated().forEach({ (index,div) in
                var image = try div.select("img").attr("src")
                image = websiteDomain + image
                let title = try div.select("strong").select("a").text()
                let p = try div.select("p[class='ext']")
                let desc = try p.text()
                var time = try p.select("span").text()
                time = time.components(separatedBy: " ").first ?? ""
                let price = try p.select("font").text()
                let detailPath = try p.select("a").attr("href")
                
                print("title:\(title)\n image:\(image)\n detail:\(detailPath) \n desc:\(desc) \n time:\(time)")
                
                let news = News(id: index, cover: image, title: title, desc: desc,time:time,detailPath:detailPath,price: price)
                
                newsArray.append(news)

            })
            
        } catch   {
            
            print("error")
        }
        
        if newsArray.isEmpty {
            return try ResponseJSON<Empty>(status: .ok,message: "暂时没有更多资讯!").encode(for: req)
        }
        
        return try ResponseJSON<[News]>(data: newsArray).encode(for: req)
        

    }
}


// 详情信息
extension CategoryController{
    
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
                    if !text.trimmingCharacters(in: .whitespaces).isEmpty{
                        contentArray.append(DetailConentInfo(id: index, content: text, isImage: false))
                    }
                }
                
            })
            
            let table = try bodyTable.select("table")
            let trs = try table.select("tr")
            
            var grids = [GridInfo]()
            try trs.enumerated().forEach({ (index,tr) in
                
                let tds = try tr.select("td")
                let ths = try tr.select("th")
                
                if index == 0 && tds.size() + ths.size() == 1{
                    
                    var title = try tds.select("strong").text()
                    
                    if title.isEmpty {
                        title = try ths.text()
                    }
                    
                    let grid = GridInfo(id: nil, content: [title], isTitle: true)
                    grids.append(grid)
                }else{
                    
                    var contents = [String]()
                    
                    for th in ths {
                        
                        let title = try th.text()
                        contents.append(title)
                    }

                    for td in tds {
                        
                        if let strong = try td.select("strong").first() {
                            let title = try strong.text()
                            contents.append(title)
                        }else{
                            let content = try td.text()
                            contents.append(content)

                        }
                    }
                    
                    
                    let grid = GridInfo(id: nil, content: contents, isTitle: false)
                    grids.append(grid)
                    
                }
                
            })
            
            detail = NewsDetail(id: nil, title: title, time: time, editor: editor, contentArray: contentArray,grids: grids)

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

