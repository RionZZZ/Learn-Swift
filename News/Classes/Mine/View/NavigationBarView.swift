//
//  NavigationBarView.swift
//  News
//
//  Created by Rion on 2019/2/21.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class NavigationBarView: UIView, NibLoadable {

    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backButton.theme_setImage("images.personal_home_back_white", forState: .normal)
        moreButton.theme_setImage("images.new_morewhite_titlebar", forState: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        height = navigationBar.frame.maxY
    }
    
    @IBAction func BackButtonClick(_ sender: UIButton) {
    }
    
    @IBAction func moreButtonClick(_ sender: UIButton) {
    }
    
}
