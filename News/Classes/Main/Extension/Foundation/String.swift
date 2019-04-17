//
//  String.swift
//  News
//
//  Created by Rion on 2019/4/17.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

extension String {
    
    func textHeight(fontSize: CGFloat, width: CGFloat) -> CGFloat {
        return self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: fontSize)], context: nil).size.height
    }
}
