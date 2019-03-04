//
//  Theme.swift
//  News
//
//  Created by Rion on 2019/2/16.
//  Copyright © 2019年 Rion. All rights reserved.
//

import Foundation
import SwiftTheme

enum Theme: Int {
    
    case day = 0
    case night = 1
    
    static var before = Theme.day
    static var current = Theme.day
    
    static func switchTo(_ theme: Theme) {
        before = current
        current = theme
        
        switch theme {
        case .day:
            ThemeManager.setTheme(plistName: "default_theme", path: .mainBundle)
        case .night:
            ThemeManager.setTheme(plistName: "night_theme", path: .mainBundle)
        }
    }
    
    static func switchNight(_ isToNight: Bool) {
        switchTo(isToNight ? .night : .day)
    }
    
    static func isNight() -> Bool {
        return current == .night
    }
    
}

struct ThemeStyle {
    
    static func setDayNavigationStyle(_ viewController: UIViewController) {
        viewController.navigationController?.navigationBar.barStyle = .default
        viewController.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_background_white"), for: .default)
        viewController.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    static func setNightNavigationStyle(_ viewController: UIViewController) {
        viewController.navigationController?.navigationBar.barStyle = .black
        viewController.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_background_white_night"), for: .default)
        viewController.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.grayColor113()]
    }
}
