//
//  BottomPresentationController.swift
//  News
//
//  Created by Rion on 2019/2/21.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class BottomPresentationController: UIPresentationController {

    var presentFrame: CGRect?
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissPresentController), name: NSNotification.Name(rawValue: BottomPresentationControllerDismiss), object: nil)
    }
    
    //即将布局转场子视图时调用
    override func containerViewWillLayoutSubviews() {
        //修改弹出视图的大小
        presentedView?.frame = presentFrame!
        //添加覆盖图层
        let coverView = UIView(frame: UIScreen.main.bounds)
        coverView.backgroundColor = .clear
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPresentController))
        coverView.addGestureRecognizer(tap)
        containerView?.insertSubview(coverView, at: 0)
    }
    
    //移除弹出的控制器
    @objc func dismissPresentController() {
        presentedViewController.dismiss(animated: false, completion: nil)
    }
    
    
}
