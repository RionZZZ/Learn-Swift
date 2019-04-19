//
//  HuoshanNavigationView.swift
//  News
//
//  Created by Rion on 2019/4/18.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import SGPagingView

class HuoshanNavigationView: UIView {

    var pageTitleViewSelected: ((_ index: Int)->())?
    
    var pageTitleView: SGPageTitleView?
    var titleNames = [String]() {
        didSet {
            pageTitleView = SGPageTitleView(frame: CGRect(x: -10, y: 0, width: screenWidth, height: 44), delegate: self, titleNames: titleNames, configure: SGPageTitleViewConfigure())
            pageTitleView!.backgroundColor = .clear
            addSubview(pageTitleView!)
        }
    }
    
    //控件的固有属性大小
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    override var frame: CGRect {
        didSet {
            super.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 44)
        }
    }

}

extension HuoshanNavigationView: SGPageTitleViewDelegate {
    
    func pageTitleView(_ pageTitleView: SGPageTitleView!, selectedIndex: Int) {
        pageTitleViewSelected?(selectedIndex)
    }
    
}
