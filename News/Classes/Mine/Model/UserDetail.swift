//
//  UserDetail.swift
//  News
//
//  Created by Rion on 2019/2/19.
//  Copyright © 2019年 Rion. All rights reserved.
//

import Foundation
import HandyJSON

// MARK: 用户详情模型
struct UserDetail: HandyJSON {
    
    var screen_name: String = ""
    var name: String = ""
    
    var big_avatar_url: String = "" // 头像
    var avatar_url: String = ""
    
    var status: Int = 0
    
    var is_followed: Bool = false
    var is_following: Bool = false // 是否正在关注
    
    var current_user_id: Int = 0
    
    var media_id: Int = 0               // 1554769814257666
    var ugc_publish_media_id: Int = 0   // 1576963425007630
    var user_id: Int = 0                // 53271122458
    var creator_id: Int = 0             // 53271122458
    
    var description: String = "" // 考研规划“神嘴”张雪峰老师。
    // screeenWidth - (15 + 15 + 40 + 5)
    var descriptionHeight: CGFloat? {
        return description.boundingRect(with: CGSize(width: screenWidth - 30, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes:[.font: UIFont.systemFont(ofSize:13)], context: nil).size.height + 5
    }
    
    var apply_auth_url: String = "" // sslocal://apply_user_auth_info
    
    var bottom_tab: [BottomTab] = [BottomTab]()
    var top_tab: [TopTab] = [TopTab]()
    
    var bg_img_url: String = ""
    
    var verified_content: String = ""
    var user_verified: Bool = false
    
    var verified_agency: String = "" // 头条认证
    
    var is_blocking: Bool = false
    var is_blocked: Bool = false
    
    var gender: Int = 0
    
    var share_url: String = ""
    
    var followers_count: Int = 0// 粉丝 470837
    var followersCount: String? {
        guard followers_count >= 10000 else {
            return String(describing: followers_count)
        }
        return String(format: "%.1f万", CGFloat(followers_count) / 10000)
    }
    
    var followings_count: Int = 0 // 关注 3
    var followingsCount: String? {
        guard followers_count >= 10000 else {
            return String(describing: followings_count)
        }
        return String(format: "%.1f万", CGFloat(followings_count) / 10000)
    }
    
    var media_type: Int = 0
    
    var area: String = ""
    
    var user_auth_info: String = ""
    
    var userAuthInfo : UserAuthInfo? {
        return UserAuthInfo.deserialize(from: user_auth_info )
    }
}

// MARK: 用户详情底部 tab
struct BottomTab: HandyJSON {
    
    var type: String = "" // href
    
    var name: String = ""
    
    var value: String = ""
    
    var children: [BottomTabChildren] = [BottomTabChildren]()
    
}

struct BottomTabChildren: HandyJSON {
    
    var schema_href: String = "" // sslocal://webview?url=http%3A%2F%2Fwww.guanfumuseum.org.cn%2F
    
    var type: String = "" // href
    
    var name: String = ""
    
    var value: String = "" // http://www.guanfumuseum.org.cn/
}

enum TopTabType: String, HandyJSONEnum {
    case dongtai = "dongtai"                            // 动态
    case article = "all"                                // 文章
    case video = "video"                                // 视频
    case wenda = "wenda"                                // 问答
    case iesVideo = "ies_video"                         // 小视频
    //    case matrix_atricle_list = "matrix_atricle_list"    // 发布厅
    //    case matrix_media_list = "matrix_media_list"        // 矩阵
}

struct TopTab: HandyJSON {
    
    var url: String = ""
    
    var is_default: Bool = false
    
    var show_name: String = "" // 动态 文章 视频 问答
    
    var type: TopTabType = .dongtai
    
}

// MARK: 关注用户
struct ConcernUser: HandyJSON {
    
    var is_followed: Bool = false
    var is_following: Bool = false // 是否正在关注
    
    var media_id: Int = 0               // 1554769814257666
    
    var create_time: TimeInterval = 0
    
    var user_verified: Bool = false
    
    var screen_name: String = "" // 考研张雪峰
    var name: String = "" // 考研张雪峰
    
    var user_id: Int = 0                // 53271122458
    
    var last_update: String = ""
    
    var avatar_url: String = ""
    
    var user_auth_info: String = ""
    
    var userAuthInfo : UserAuthInfo? {
        return UserAuthInfo.deserialize(from: user_auth_info )
    }
    
    var type: Int = 0
}

// MARK: 相关推荐模型
struct UserCard: HandyJSON {
    
    var name: String = ""
    
    var recommend_reason: String = ""
    
    var recommend_type: Int = 0
    
    var user: UserCardUser = UserCardUser()
    
    var stats_place_holder: String = ""
    
}

// MARK: 相关推荐的用户模型
struct UserCardUser: HandyJSON {
    
    var info: UserCardUserInfo = UserCardUserInfo()
    
    var relation: UserCardUserRelation = UserCardUserRelation()
    
}

// MARK: 相关推荐的用户信息模型
struct UserCardUserInfo: HandyJSON {
    
    var name: String = ""
    
    var user_id: Int = 0
    
    var avatar_url: String = ""
    
    var desc: String = ""
    
    var schema: String = ""
    
    var user_auth_info: String = ""
    
    var userAuthInfo : UserAuthInfo? {
        return UserAuthInfo.deserialize(from: user_auth_info )
    }
}

// MARK: 相关推荐的用户是否关注模型
struct UserCardUserRelation: HandyJSON {
    
    var is_followed: Bool = false
    
    var is_following: Bool = false
    
    var is_friend: Bool = false
    
}
