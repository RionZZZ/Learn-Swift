//
//  HomeNavigationBar.swift
//  News
//
//  Created by Rion on 2019/3/4.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import IBAnimatable

class HomeNavigationBar: UIView, NibLoadable {

    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var searchButton: AnimatableButton!
    
    var didSelectedAvatar: (()->())?
    var didSelectedSearch: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        searchButton.setImage(UIImage(named: "search_samll_16x16_"), for: [.normal, .highlighted])
//        searchButton.theme_setTitleColor("", forState: .normal)
        searchButton.theme_backgroundColor = "colors.cellBackgroundColor"
        searchButton.contentHorizontalAlignment = .left
        searchButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        searchButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        //按钮文字超出，默认中间显示‘···’，改为右边
        searchButton.titleLabel?.lineBreakMode = .byTruncatingTail
        
        avatarButton.theme_setImage("images.homeHead", forState: .normal)
        avatarButton.theme_setImage("images.homeHead", forState: .highlighted)
        
        Network.loadHomeSearchSuggest { (suggestInfo) in
            self.searchButton.setTitle(suggestInfo, for: .normal)
        }
    }
    
    //控件的固有属性大小
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
//    重写frame
//    override var frame: CGRect {
//        didSet {
//            super.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 44)
//        }
//    }
    
   
    @IBAction func avatarClick(_ sender: UIButton) {
        didSelectedAvatar?()
    }
    
    @IBAction func searchClick(_ sender: AnimatableButton) {
        didSelectedSearch?()
    }
    
}
