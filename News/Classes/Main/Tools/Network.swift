//
//  Network.swift
//  News
//
//  Created by Rion on 2019/2/15.
//  Copyright © 2019年 Rion. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SVProgressHUD

protocol NetworkProtocol {
    //我的界面cell
    static func loadMineCellData(completionHandler: @escaping (_ sections: [[MineCellModel]]) -> ())
    
    //我的关注
    static func loadMineConcern(completionHandler: @escaping (_ concerns: [MineConcernModel]) -> ())
    
    //首页顶部新闻标题
    static func loadHomeNewsTitle(completionHandler: @escaping (_ newsTitles: [HomeNewsTitleModel]) -> ())
    
    //用户详情
    static func loadUserDetail(user_id: Int, completionHandler: @escaping (_ userDetail: UserDetail)  -> ())
    
    //取消关注用户
    static func relationUnfollow(user_id: Int, completionHandler: @escaping (_ user: ConcernUser)  -> ())
    
    //关注用户
    static func relationFollow(user_id: Int, completionHandler: @escaping (_ user: ConcernUser)  -> ())
    
    //推荐关注
    static func loadRelationUserRecommand(user_id: Int, completionHandler: @escaping (_ concerns: [UserCard]) -> ())
    
    //用户动态表格
    static func loadUserDetailDongtai(user_id: Int, completionHandler: @escaping (_ dongtais: [UserDetailDongtai])  -> ())
    
    //首页顶部搜索内容
    static func loadHomeSearchSuggest(completionHandler: @escaping (_ suggestInfo: String) -> ())
    
    //用户详情动态列表数据
    static func loadUserDetailDongtaiList(userId: Int, maxCursor: Int, completionHandler: @escaping (_ cursor: Int,_ dongtais: [UserDetailDongtai]) -> ())
    
    //用户详情问答列表数据
    static func loadUserDetailWenDaList(userId: Int, cursor: String, completionHandler: @escaping (_ cursor: String,_ wendas: [UserDetailWenda]) -> ())
    
    //用户详情评论列表
    static func loadUserDetailNormalComments(groupId: Int, count: Int, offset: Int, completionHandler: @escaping (_ comments: [DongtaiComment]) -> ())
    
    //其他类型用户详情评论列表
    static func loadUserDetailQuoteComments(detailId: Int, offset: Int, completionHandler: @escaping (_ comments: [DongtaiComment]) -> ())
    
    //加载动态点赞列表
    static func loadUserDongtaiDetailDiggList(detailId: Int, offset: Int, completionHandler: @escaping (_ comments: [DongtaiUserDigg]) -> ())
    
    //问答列表
    static func loadProposeQuestionList(qid: Int, enterForm: String, completionHandler: @escaping (_ comments: Wenda) -> ())
    
    //问答列表加载更多
    static func loadMoreProposeQuestionList(qid: Int, enterForm: String, offset: Int, completionHandler: @escaping (_ comments: Wenda) -> ())
    
    //获取首页、视频、小视频的列表
    static func loadApiNewsFeeds(category: String, ttForm: TTFrom, completionHandler: @escaping (_ maxBehotTime: TimeInterval, _ news: [NewsModel]) -> ())
    
    //首页、视频、小视频列表加载更多
    static func loadMoreApiNewsFeeds(category: Int, ttForm: TTFrom, maxBehotTime: TimeInterval, listConut: Int, completionHandler: @escaping (_ news: [NewsModel]) -> ())
    
    //视频顶部新闻标题
    static func loadSmallVideoNewsTitle(completionHandler: @escaping (_ newsTitles: [HomeNewsTitleModel]) -> ())
    
    
    
}

extension NetworkProtocol {
    //我的界面cell
    static func loadMineCellData(completionHandler: @escaping (_ sections: [[MineCellModel]]) -> ()){
        let url = BASE_URL + "/user/tab/tabs/?"
        let params = ["device_id": device_id]
        Alamofire.request(url, parameters: params).responseJSON { res in
            guard res.result.isSuccess else {
                //提示网络错误
                print("网络连接错误!!")
                return
            }
            if let value = res.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else {
                    //提示接口错误
                    print("接口调用错误!!")
                    return
                }
                if let data = json["data"].dictionary {
                    if let sections = data["sections"]?.arrayObject {
//                        var sectionArray = [[MineCellModel]]()
//                        for item in sections {
//                            var rows = [MineCellModel]()
//                            for row in item.arrayObject! {
//                                let mineCellModel = MineCellModel.deserialize(from: row as? NSDictionary)
//                                rows.append(mineCellModel!)
//                            }
//                            sectionArray.append(rows)
//                        }
//                        completionHandler(sectionArray)
                        
                        completionHandler(sections.compactMap({ item in
                            (item as! [Any]).compactMap({
                                MineCellModel.deserialize(from: $0 as? NSDictionary)
                            })
                        }))
                    }
                }
            }
            
        }
    }
    
    //我的关注
    static func loadMineConcern(completionHandler: @escaping (_ concerns: [MineConcernModel]) -> ()){
            let url = BASE_URL + "/concern/v2/follow/my_follow/?"
            let params = ["device_id": device_id]
            Alamofire.request(url, parameters: params).responseJSON { res in
                guard res.result.isSuccess else {
                    //提示网络错误
                    print("网络连接错误!!")
                    return
                }
                if let value = res.result.value {
                    let json = JSON(value)
                    guard json["message"] == "success" else {
                        //提示接口错误
                        print("接口调用错误!!")
                        return
                    }
                    if let datas = json["data"].arrayObject {
//                        var concerns = [MineConcernModel]()
//                        for data in datas {
//                            let mineFirstSectionCell = MineConcernModel.deserialize(from: data as? NSDictionary)
//                            concerns.append(mineFirstSectionCell!)
//                        }
//                        completionHandler(concerns)
                        completionHandler(datas.compactMap({
                            MineConcernModel.deserialize(from: $0 as? NSDictionary)
                        }))
                    }
                }
                
            }
    }
    
    //首页顶部新闻标题
    static func loadHomeNewsTitle(completionHandler: @escaping (_ newsTitles: [HomeNewsTitleModel]) -> ()){
        let url = BASE_URL + "/article/category/get_subscribed/v1/?"
        let params = ["device_id": device_id, "iid": iid]
        Alamofire.request(url, parameters: params).responseJSON { res in
            guard res.result.isSuccess else {
                //提示网络错误
                print("网络连接错误!!")
                return
            }
            if let value = res.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else {
                    //提示接口错误
                    print("接口调用错误!!")
                    return
                }
                if let dataDict = json["data"].dictionary {
                    if let data = dataDict["data"]?.arrayObject {
                        var titles = [HomeNewsTitleModel]()
                        let jsonString = "{\"category\": \"\", \"name\": \"推荐\"}"
                        let recommend = HomeNewsTitleModel.deserialize(from: jsonString)
                        titles.append(recommend!)
                        for item in data {
                            let newsTitle = HomeNewsTitleModel.deserialize(from: item as? NSDictionary)
                            titles.append(newsTitle!)
                        }
                        completionHandler(titles)
                    }
                }
            }
            
        }
    }
    
    //用户详情
    static func loadUserDetail(user_id: Int, completionHandler: @escaping (_ userDetail: UserDetail)  -> ()){
        let url = BASE_URL + "/user/profile/homepage/v4/?"
        let params = ["device_id": device_id, "iid": iid, "user_id": user_id] as [String : Any]
        Alamofire.request(url, parameters: params).responseJSON { res in
            guard res.result.isSuccess else {
                //提示网络错误
                print("网络连接错误!!")
                return
            }
            if let value = res.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else {
                    //提示接口错误
                    print("接口调用错误!!")
                    return
                }
                if let data = json["data"].dictionaryObject {
                    let userDetail = UserDetail.deserialize(from: data as Dictionary)
                    completionHandler(userDetail!)
                }
            }
            
        }
    }
    
    //取消关注用户
    static func relationUnfollow(user_id: Int, completionHandler: @escaping (_ user: ConcernUser)  -> ()){
        let url = BASE_URL + "/2/relation/unfollow/?"
        let params = ["device_id": device_id, "iid": iid, "user_id": user_id] as [String : Any]
        Alamofire.request(url, parameters: params).responseJSON { res in
            guard res.result.isSuccess else {
                //提示网络错误
                print("网络连接错误!!")
                return
            }
            if let value = res.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else {
                    //提示接口错误
                    if let data = json["data"].dictionaryObject {
                        SVProgressHUD.showInfo(withStatus: data["description"] as? String)
                        SVProgressHUD.setForegroundColor(UIColor.white)
                        SVProgressHUD.setBackgroundColor(UIColor(r: 0, g: 0, b: 0, alpha: 0.3))
                    }
                    return
                }
                if let data = json["data"].dictionaryObject {
                    let user = ConcernUser.deserialize(from: data["user"] as? Dictionary)
                    completionHandler(user!)
                }
            }
            
        }
    }
    
    //关注用户
    static func relationFollow(user_id: Int, completionHandler: @escaping (_ user: ConcernUser)  -> ()){
        let url = BASE_URL + "/2/relation/follow/v2/?"
        let params = ["device_id": device_id, "iid": iid, "user_id": user_id] as [String : Any]
        Alamofire.request(url, parameters: params).responseJSON { res in
            guard res.result.isSuccess else {
                //提示网络错误
                print("网络连接错误!!")
                return
            }
            if let value = res.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else {
                    //提示接口错误
                    if let data = json["data"].dictionaryObject {
                        SVProgressHUD.showInfo(withStatus: data["description"] as? String)
                        SVProgressHUD.setForegroundColor(UIColor.white)
                        SVProgressHUD.setBackgroundColor(UIColor(r: 0, g: 0, b: 0, alpha: 0.3))
                    }
                    return
                }
                if let data = json["data"].dictionaryObject {
                    let user = ConcernUser.deserialize(from: data["user"] as? Dictionary)
                    completionHandler(user!)
                }
            }
            
        }
    }
    
    //推荐关注
    static func loadRelationUserRecommand(user_id: Int, completionHandler: @escaping (_ concerns: [UserCard]) -> ()){
        let url = BASE_URL + "/user/relation/user_recommend/v1/supplement_recommends/?"
        let params = ["device_id": device_id, "iid": iid, "follow_user_id": user_id, "scene": "follow", "source": "follow"] as [String : Any]
        Alamofire.request(url, parameters: params).responseJSON { res in
            guard res.result.isSuccess else {
                //提示网络错误
                print("网络连接错误!!")
                return
            }
            if let value = res.result.value {
                let json = JSON(value)
                guard json["err_no"] == 0 else {
                    //提示接口错误
                    print("接口调用错误!!")
                    return
                }
                if let user_cards = json["user_cards"].arrayObject {
                    completionHandler(user_cards.compactMap({
                        UserCard.deserialize(from: $0 as? NSDictionary)
                    }))
                }
            }
            
        }
    }
    
    //用户动态表格
    static func loadUserDetailDongtai(user_id: Int, completionHandler: @escaping (_ dongtais: [UserDetailDongtai])  -> ()){
        let url = BASE_URL + "/dongtai/list/v15/?"
        let params = ["user_id": user_id]
        Alamofire.request(url, parameters: params).responseJSON { res in
            guard res.result.isSuccess else {
                //提示网络错误
                print("网络连接错误!!")
                return
            }
            if let value = res.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else {
                    //提示接口错误
                    print("接口调用错误!!")
                    return
                }
                if let data = json["data"].dictionary {
                    if let datas = data["data"]?.arrayObject {
                        completionHandler(datas.compactMap({
                            UserDetailDongtai.deserialize(from: $0 as? NSDictionary)
                        }))
                    }
                }
            }
            
        }
    }
    
    //用户详情文章
    static func loadUserDetailArticle(user_id: Int, completionHandler: @escaping (_ articles: [UserDetailDongtai])  -> ()){
        let url = BASE_URL + "/pgc/ma/?"
        let params = ["uid": user_id,
                      "page_type": 1,
                      "media_id": user_id,
                      "output": "json",
                      "is_json": 1,
                      "from": "user_profile_app",
                      "version": 2,
                      "as": "A1157A8297BEED7",
                      "cp": "59549FCDF1885E1"] as [String: Any]
        Alamofire.request(url, parameters: params).responseJSON { res in
            guard res.result.isSuccess else {
                //提示网络错误
                print("网络连接错误!!")
                return
            }
            if let value = res.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else {
                    //提示接口错误
                    print("接口调用错误!!")
                    return
                }
                if let data = json["data"].arrayObject {
                    completionHandler(data.compactMap({
                        UserDetailDongtai.deserialize(from: $0 as? NSDictionary)
                    }))
                }
            }
            
        }
    }
    
    //首页顶部搜索内容
    static func loadHomeSearchSuggest(completionHandler: @escaping (_ suggestInfo: String) -> ()){
        let url = BASE_URL + "/search/suggest/homepage_suggest/?"
        let params = ["device_id": device_id, "iid": iid]
        Alamofire.request(url, parameters: params).responseJSON { res in
            guard res.result.isSuccess else {
                //提示网络错误
                print("网络连接错误!!")
                return
            }
            if let value = res.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else {
                    //提示接口错误
                    print("接口调用错误!!")
                    return
                }
                if let data = json["data"].dictionary {
                    completionHandler(data["homepage_search_suggest"]!.string!)
                }
            }
            
        }
    }
    
    //用户详情动态列表数据
    static func loadUserDetailDongtaiList(userId: Int, maxCursor: Int, completionHandler: @escaping (_ cursor: Int, _ dongtais: [UserDetailDongtai]) -> ()) {
        
        let url = BASE_URL + "/dongtai/list/v15/?"
        let params = ["user_id": userId,
                      "max_cursor": maxCursor,
                      "device_id": device_id,
                      "iid": iid] as [String : Any]
        
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            // 网络错误的提示信息
            guard response.result.isSuccess else { completionHandler(maxCursor, []); return }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else { completionHandler(maxCursor, []); return }
                if let data = json["data"].dictionary {
                    let max_cursor = data["max_cursor"]!.int
                    if let datas = data["data"]!.arrayObject {
                        completionHandler(max_cursor!, datas.compactMap({
                            UserDetailDongtai.deserialize(from: $0 as? Dictionary)
                        }))
                    }
                }
            }
        }
    }
    
    //用户详情问答列表数据
    static func loadUserDetailWenDaList(userId: Int, cursor: String, completionHandler: @escaping (_ cursor: String, _ wendas: [UserDetailWenda]) -> ()) {
        
        let url = BASE_URL + "/wenda/profile/wendatab/brow/?"
        let params = ["other_id": userId,
                      "format": "json",
                      "max_cursor": cursor,
                      "device_id": device_id,
                      "iid": iid] as [String : Any]
        
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            // 网络错误的提示信息
            guard response.result.isSuccess else { completionHandler(cursor, []); return }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["err_no"] == 0 else { completionHandler(cursor, []); return }
                if let answerQuestions = json["answer_question"].arrayObject {
                    if (answerQuestions.count == 0) {
                        completionHandler(cursor, [])
                    } else {
                        let cursor = json["cursor"].string
                        completionHandler(cursor!, answerQuestions.compactMap({
                            UserDetailWenda.deserialize(from: $0 as? Dictionary)
                        }))
                    }
                }
            }
        }
    }
    
    //用户详情评论列表
    static func loadUserDetailNormalComments(groupId: Int, count: Int, offset: Int, completionHandler: @escaping (_ comments: [DongtaiComment]) -> ()) {
        
        let url = BASE_URL + "/article/v2/tab_comments/"
        let params = ["forum_id": "",
                      "group_id": groupId,
                      "count": count,
                      "offset": offset,
                      "device_id": device_id,
                      "iid": iid] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: params).responseJSON { (response) in
            // 网络错误的提示信息
            guard response.result.isSuccess else { completionHandler([]); return }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else { completionHandler([]); return }
                if let datas = json["data"].arrayObject {
                    completionHandler(datas.compactMap({
                        DongtaiComment.deserialize(from: ($0 as! [String: Any])["comment"] as? Dictionary)
                    }))
                }
            }
        }
    }
    
    //其他类型用户详情评论列表
    static func loadUserDetailQuoteComments(detailId: Int, offset: Int, completionHandler: @escaping (_ comments: [DongtaiComment]) -> ()) {
        
        let url = BASE_URL + "/2/comment/v1/reply_list/?"
        let params = ["id": detailId,
                      "count": 20,
                      "offset": offset,
                      "device_id": device_id,
                      "iid": iid] as [String : Any]
        
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            // 网络错误的提示信息
            guard response.result.isSuccess else { completionHandler([]); return }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else { completionHandler([]); return }
                if let data = json["data"].dictionary {
                    if let datas = data["data"]!.arrayObject {
                        completionHandler(datas.compactMap({ DongtaiComment.deserialize(from: $0 as? Dictionary) }))
                    }
                }
            }
        }
    }
    
    //加载动态点赞列表
    static func loadUserDongtaiDetailDiggList(detailId: Int, offset: Int, completionHandler: @escaping (_ comments: [DongtaiUserDigg]) -> ()) {
        
        let url = BASE_URL + "/2/comment/v1/digg_list/?"
        let params = ["id": detailId,
                      "count": 20,
                      "offset": offset,
                      "device_id": device_id,
                      "iid": iid] as [String : Any]
        
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            // 网络错误的提示信息
            guard response.result.isSuccess else { completionHandler([]); return }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else { completionHandler([]); return }
                if let data = json["data"].dictionary {
                    if let datas = data["data"]!.arrayObject {
                        completionHandler(datas.compactMap({ DongtaiUserDigg.deserialize(from: $0 as? Dictionary) }))
                    }
                }
            }
        }
    }
    
    //问答列表
    static func loadProposeQuestionList(qid: Int, enterForm: String, completionHandler: @escaping (_ comments: Wenda) -> ()) {
        
        let url = BASE_URL + "/wenda/v1/question/brow/?device_id=\(device_id)&iid=\(iid)"
        let params = ["qid": qid,
                      "enter_form": enterForm] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: params).responseJSON { (response) in
            // 网络错误的提示信息
            guard response.result.isSuccess else { return }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["err_no"] == 0 else { return }
                completionHandler(Wenda.deserialize(from: json.dictionaryObject)!)
            }
        }
    }
    
    //问答列表加载更多
    static func loadMoreProposeQuestionList(qid: Int, enterForm: String, offset: Int, completionHandler: @escaping (_ comments: Wenda) -> ()) {
        
        let url = BASE_URL + "/wenda/v1/question/loadmore/?device_id=\(device_id)&iid=\(iid)"
        let params = ["qid": qid,
                      "enter_form": enterForm,
                      "count": 20,
                      "offset": offset] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: params).responseJSON { (response) in
            // 网络错误的提示信息
            guard response.result.isSuccess else { return }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["err_no"] == 0 else { return }
                completionHandler(Wenda.deserialize(from: json.dictionaryObject)!)
            }
        }
    }
    
    
    //获取首页、视频、小视频的列表
    static func loadApiNewsFeeds(category: String, ttForm: TTFrom, completionHandler: @escaping (_ maxBehotTime: TimeInterval, _ news: [NewsModel]) -> ()) {
        
        let pullTime = Date().timeIntervalSince1970
        let url = BASE_URL + "/api/news/feed/v75/?"
        let params = ["category": category,
                      "tt_form": ttForm,
                      "count": 20,
                      "list_count": 15,
                      "min_behot_time": pullTime,
                      "strict": 0,
                      "detail": 1,
                      "refresh_reason": 1,
                      "device_id": device_id] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: params).responseJSON { (response) in
            // 网络错误的提示信息
            guard response.result.isSuccess else { return }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else { return }
                
                guard let datas = json["data"].array else { return }
                completionHandler(pullTime, datas.compactMap({ NewsModel.deserialize(from: $0["content"].string) }))
            }
        }
    }
    
    //首页、视频、小视频列表加载更多
    static func loadMoreApiNewsFeeds(category: Int, ttForm: TTFrom, maxBehotTime: TimeInterval, listConut: Int, completionHandler: @escaping (_ news: [NewsModel]) -> ()) {
        
        let url = BASE_URL + "/api/news/feed/v75/?"
        let params = ["category": category,
                      "tt_form": ttForm,
                      "count": 20,
                      "list_count": listConut,
                      "max_behot_time": maxBehotTime,
                      "strict": 0,
                      "detail": 1,
                      "refresh_reason": 1,
                      "device_id": device_id] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: params).responseJSON { (response) in
            // 网络错误的提示信息
            guard response.result.isSuccess else { return }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else { return }
                guard let datas = json["data"].array else { return }
                completionHandler(datas.compactMap({ NewsModel.deserialize(from: $0["content"].string) }))
            }
        }
    }
    
    //小视频顶部新闻标题
    static func loadSmallVideoNewsTitle(completionHandler: @escaping (_ newsTitles: [HomeNewsTitleModel]) -> ()){
        let url = BASE_URL + "/article/category/get_subscribed/v1/?"
//        let url = BASE_URL + "/category/get_ugc_video/1/?"    //此接口无数据？？？？？
        let params = ["device_id": device_id, "iid": iid]
        Alamofire.request(url, parameters: params).responseJSON { res in
            guard res.result.isSuccess else {
                //提示网络错误
                print("网络连接错误!!")
                return
            }
            if let value = res.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else {
                    //提示接口错误
                    print("接口调用错误!!")
                    return
                }
                if let dataDict = json["data"].dictionary {
                    if let data = dataDict["data"]?.arrayObject {
                        var titles = [HomeNewsTitleModel]()
                        let jsonString = "{\"category\": \"hotsoon_video\", \"name\": \"推荐\"}"
                        let recommend = HomeNewsTitleModel.deserialize(from: jsonString)
                        titles.append(recommend!)
//                        for item in data {
//                            let newsTitle = HomeNewsTitleModel.deserialize(from: item as? NSDictionary)
//                            titles.append(newsTitle!)
//                        }
                        titles += data.compactMap({ HomeNewsTitleModel.deserialize(from: $0 as? Dictionary) })
                        completionHandler(titles)
                    }
                }
            }
            
        }
    }
}

struct Network: NetworkProtocol { }
