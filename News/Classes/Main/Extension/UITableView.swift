//
//  UITableView.swift
//  News
//
//  Created by Rion on 2019/2/16.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

extension UITableView {
    
    //注册cell
    func _registerCell<T: UITableViewCell>(cell: T.Type) where T: RegisterCellOrNib {
        if let nib = T.nib {
            register(nib, forCellReuseIdentifier: T.identifier)
        } else {
            register(cell, forCellReuseIdentifier: T.identifier)
        }
    }
    
    //从缓存池出队已经存在的cell
    func _dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T where T: RegisterCellOrNib {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
}
