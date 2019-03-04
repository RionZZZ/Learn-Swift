//
//  Date.swift
//  News
//
//  Created by Rion on 2019/3/4.
//  Copyright © 2019年 Rion. All rights reserved.
//

import Foundation

extension Date {
    
    func isThisYear() -> Bool {
        let calender = Calendar.current
        let yearComps  = calender.component(.year, from: self)
        let nowComps = calender.component(.year, from: Date())
        return yearComps == nowComps
    }
    
    func isYesterDay() -> Bool {
        let calender = Calendar.current
        let comp = calender.dateComponents([.year, .month, .day], from: self, to: Date())
        return comp.year == 0 && comp.month == 0 && comp.day == 1 //1是昨天，-1是明天
    }
    
    func isBeforeDay() -> Bool {
        let calender = Calendar.current
        let comp = calender.dateComponents([.year, .month, .day], from: self, to: Date())
        return comp.year == 0 && comp.month == 0 && comp.day == 2
    }
    
    func isToday() -> Bool {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let date = format.string(from: self)
        let now = format.string(from: Date())
        return date == now
    }
    
}


extension TimeInterval {
    
    func convertString() -> String {
        let createDate = Date(timeIntervalSince1970: self)
        let calender = Calendar.current
        let comp = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: createDate, to: Date())
        let format = DateFormatter()
        guard createDate.isThisYear() else {
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return format.string(from: createDate)
        }
        if createDate.isBeforeDay() {
            format.dateFormat = "前天 - HH:mm"
            return format.string(from: createDate)
        } else if (createDate.isYesterDay() || createDate.isToday()) {
            if comp.hour! >= 1 {
                return String(format: "%d小时前", comp.hour!)
            } else if comp.minute! >= 1 {
                return String(format: "%d分钟前", comp.minute!)
            } else {
                return "刚刚"
            }
        } else {
            format.dateFormat = "MM-dd HH:mm"
            return format.string(from: createDate)
        }
    }
}
