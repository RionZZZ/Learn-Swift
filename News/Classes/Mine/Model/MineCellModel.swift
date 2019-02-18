//
//  MineCellModel.swift
//  News
//
//  Created by Rion on 2019/2/15.
//  Copyright © 2019年 Rion. All rights reserved.
//

import Foundation
import HandyJSON

struct MineCellModel : HandyJSON {
    
    var text : String = ""
    var url : String = ""
    var key : String = ""
    var grey_text : String = ""
    var tip_new : Int = 0
}

struct MineConcernModel : HandyJSON {
    
    var name : String?
    var url : String?
    var totla_count : String?
    var description : String?
    var time : String?
    var type : String?
    var icon : String?
    var userid : Int?
    var is_verify : Bool?
    var media_id : Int?
    var tips : Bool?
    var id : Int?
    var user_auth_info : String?
    var userAuthInfo : UserAuthInfo? {
        return UserAuthInfo.deserialize(from: user_auth_info)
    }
}

struct UserAuthInfo : HandyJSON {
    var auth_type : Int?
    var auth_info : String?
}
