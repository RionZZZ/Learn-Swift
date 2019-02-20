//
//  HomeNewsTitleModel.swift
//  News
//
//  Created by Rion on 2019/2/18.
//  Copyright © 2019年 Rion. All rights reserved.
//

import Foundation
import HandyJSON

struct HomeNewsTitleModel : HandyJSON {
    
    var category : String = ""
    var tip_new : Int = 0
    var default_add : Int = 0
//    var web_url : String = ""
    var concern_id : String = ""
    var icon_url : String = ""
    var name : String = ""
    var flags : Int = 0
    var type : Int = 0
    var selected : Bool = true
}
