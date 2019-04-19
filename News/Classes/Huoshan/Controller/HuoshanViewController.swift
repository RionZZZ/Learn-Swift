//
//  HuoshanViewController.swift
//  News
//
//  Created by Rion on 2019/2/14.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import SGPagingView

class HuoshanViewController: UIViewController {
    
    var newsTitles = [HomeNewsTitleModel]()
    
    lazy var navigationBar: HuoshanNavigationView = {
        let navBar = HuoshanNavigationView()
        return navBar
    }()
    
    var pageContentView: SGPageContentCollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = navigationBar
        
        setupUI()
        
        Network.loadSmallVideoNewsTitle { (newsTitles) in
            self.newsTitles = newsTitles
            self.navigationBar.titleNames = newsTitles.compactMap({ $0.name })
            
            _ = newsTitles.compactMap({ (category) -> () in
                let categoryVC = HuoshanCategoryController()
                categoryVC.category = category
                self.addChild(categoryVC)
            })
            self.pageContentView = SGPageContentCollectionView(frame: self.view.bounds, parentVC: self, childVCs: self.children)
            self.pageContentView!.delegatePageContentCollectionView = self
            self.view.addSubview(self.pageContentView!)
        }
        
        navigationBar.pageTitleViewSelected = { [weak self] (index) in
            self!.pageContentView!.setPageContentCollectionViewCurrentIndex(index)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension HuoshanViewController {
    
    private func setupUI() {
        view.theme_backgroundColor = "colors.cellBackgroundColor"
        
        ThemeStyle.setNavigationStyle(self, UserDefaults.standard.bool(forKey: isNight))
        
        //接收更换主题通知
        NotificationCenter.default.addObserver(self, selector: #selector(receiveDayOrNightClick), name: NSNotification.Name(rawValue: "dayOrNightClick"), object: nil)
        
    }
    
    @objc func receiveDayOrNightClick(notification: Notification) {
        ThemeStyle.setNavigationStyle(self, notification.object as! Bool)
    }
    
}

extension HuoshanViewController: SGPageContentCollectionViewDelegate {
    
    func pageContentCollectionView(_ pageContentCollectionView: SGPageContentCollectionView!, progress: CGFloat, originalIndex: Int, targetIndex: Int) {
        navigationBar.pageTitleView?.setPageTitleViewWithProgress(progress, originalIndex: originalIndex, targetIndex: targetIndex)
    }
}
