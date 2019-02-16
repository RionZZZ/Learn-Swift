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

protocol NetworkProtocol {
    //我的界面cell
    static func loadMineCellData(completionHandler: @escaping (_ sections:[[MineCellModel]]) -> ())
    
    //我的关注
    static func loadMineConcern(completionHandler: @escaping (_ concerns:[MineConcernModel]) -> ())
}

extension NetworkProtocol {
    //我的界面cell
    static func loadMineCellData(completionHandler: @escaping (_ sections:[[MineCellModel]]) -> ()){
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
                    if let sections = data["sections"]?.array {
                        var sectionArray = [[MineCellModel]]()
                        for item in sections {
                            var rows = [MineCellModel]()
                            for row in item.arrayObject! {
                                let mineCellModel = MineCellModel.deserialize(from: row as? NSDictionary)
                                rows.append(mineCellModel!)
                            }
                            sectionArray.append(rows)
                        }
                        completionHandler(sectionArray)
                    }
                }
            }
            
        }
    }
    
    //我的关注
    static func loadMineConcern(completionHandler: @escaping (_ concerns:[MineConcernModel]) -> ()){
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
                        var concerns = [MineConcernModel]()
                        for data in datas {
                            let mineFirstSectionCell = MineConcernModel.deserialize(from: data as? NSDictionary)
                            concerns.append(mineFirstSectionCell!)
                        }
                        completionHandler(concerns)
                    }
                }
                
            }
    }
    
}

struct Network : NetworkProtocol {}
