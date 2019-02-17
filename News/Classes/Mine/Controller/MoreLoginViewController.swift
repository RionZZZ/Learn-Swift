//
//  MoreLoginViewController.swift
//  News
//
//  Created by Rion on 2019/2/17.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import IBAnimatable

class MoreLoginViewController: AnimatableModalViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func onCloseClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
