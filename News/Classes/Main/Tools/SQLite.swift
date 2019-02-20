//
//  SQLite.swift
//  News
//
//  Created by Rion on 2019/2/18.
//  Copyright © 2019年 Rion. All rights reserved.
//

import Foundation
import SQLite

struct SQLiteManager {
    var database: Connection!
    init() {
        do {
            let path = NSHomeDirectory() + "/Documents/news.sqlite3"
            database = try Connection(path)
        } catch {
            print(error)
        }
    }
}

//首页分类标题数据表
struct NewsTitleTable {
    //数据库管理者
    private let sqlManager = SQLiteManager()
    //新闻标题表
    private let news_title = Table("news_title")
    //表字段
    let id = Expression<Int64>("id")
    let category = Expression<String>("category")
    let tip_new = Expression<Int64>("tip_new")
    let default_add = Expression<Int64>("default_add")
//    let web_url = Expression<String>("web_url")
    let concern_id = Expression<String>("concern_id")
    let icon_url = Expression<String>("icon_url")
    let name = Expression<String>("name")
    let flags = Expression<Int64>("flags")
    let type = Expression<Int64>("type")
    let selected = Expression<Bool>("selected")
    
    init() {
        do {
            //建表
            try sqlManager.database.run(news_title.create(ifNotExists: true, block: { t in
                t.column(id, primaryKey: true)
                t.column(category)
                t.column(tip_new)
                t.column(default_add)
//                t.column(web_url)
                t.column(concern_id)
                t.column(icon_url)
                t.column(name)
                t.column(flags)
                t.column(type)
                t.column(selected)
            }))
        } catch {
            print(error)
        }
    }
    
    //插入一组数据
    func insert (_ titles: [HomeNewsTitleModel]) {
        //遍历
//        for title in titles {
//            insert(title)
//        }
        _ = titles.compactMap({
            insert($0)
        })
    }
    
    //插入一条数据
    func insert(_ title: HomeNewsTitleModel) {
        //数据不存在，就插入
        if !isExist(title) {
            let insert = news_title.insert(category <- title.category, tip_new <- Int64(title.tip_new), default_add <- Int64(title.default_add), concern_id <- title.concern_id, icon_url <- title.icon_url, flags <- Int64(title.flags), type <- Int64(title.type), name <- title.name, selected <- title.selected)
            do {
                //插入数据
                try sqlManager.database.run(insert)
            } catch {
                print(error)
            }
        }
    }
    
    //数据库中是否存在该数据
    func isExist(_ title: HomeNewsTitleModel) -> Bool {
        //取出该新闻分类标题的数据
        let title = news_title.filter(category == title.category)
        do {
            //判断此数据是否存在。 由count是否为0来作为依据
            let count = try sqlManager.database.scalar(title.count)
            return count != 0
        } catch {
            print(error)
        }
        return false
    }
    
    //查询所有数据
    func selectAll() -> [HomeNewsTitleModel] {
        var allTitles = [HomeNewsTitleModel]()
        do {
            for title in try sqlManager.database.prepare(news_title) {
                //取出表中数据，并初始化为结构体模型
                let newsTitle = HomeNewsTitleModel(category: title[category], tip_new: Int(title[tip_new]), default_add: Int(title[default_add]), concern_id: title[concern_id], icon_url: title[icon_url], name: title[name], flags: Int(title[flags]), type: Int(title[type]), selected: title[selected])
                
                allTitles.append(newsTitle)
            }
            return allTitles
        } catch {
            print(error)
        }
        return []
    }
    
    //更新表数据
    func update(_ newsTitle: HomeNewsTitleModel) {
        do {
            let title = news_title.filter(category == newsTitle.category)
            //更新数据
            try sqlManager.database.run(title.update(selected <- newsTitle.selected))
        } catch {
            print(error)
        }
    }
    
}

