//
//  UserDetailBottomPushViewController.swift
//  News
//
//  Created by Rion on 2019/2/21.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import WebKit

class UserDetailBottomPushController: UIViewController {
    
    var url: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        let webview = WKWebView()
        webview.frame = view.bounds
        webview.load(URLRequest(url: URL(string: url!)!))
        view.addSubview(webview)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}
