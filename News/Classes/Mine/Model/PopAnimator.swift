//
//  PopAnimator.swift
//  News
//
//  Created by Rion on 2019/2/21.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    //展现视图的大小
    var presentFrame: CGRect?
    //记录当前是否打开
    var isPresent: Bool = false
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentController = BottomPresentationController(presentedViewController: presented, presenting: presenting)
        presentController.presentFrame = presentFrame!
        return presentController
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    //展开关闭
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            //获取展现视图
            let toView = transitionContext.view(forKey: .to)
            toView?.transform = CGAffineTransform(scaleX: 0, y: 0)
            transitionContext.containerView.addSubview(toView!)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toView?.transform = .identity
            }) { (_) in
                transitionContext.completeTransition(true)
            }
        } else {
            //获取关闭视图
            let fromView = transitionContext.view(forKey: .from)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromView?.transform = CGAffineTransform(scaleX: 0, y: 0)
            }) { (_) in
                transitionContext.completeTransition(true)
            }
        }
    }
    //告诉系统谁来负责Modal的消失动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
    //系统默认动画消失
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    
    
}
