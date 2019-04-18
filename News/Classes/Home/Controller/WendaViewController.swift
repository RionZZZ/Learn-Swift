//
//  WendaViewController.swift
//  News
//
//  Created by Rion on 2019/4/12.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import SVProgressHUD

class WendaViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var bottomView: WendaAnswerBottomView!
    @IBOutlet weak var bottomViewBottom: NSLayoutConstraint!
    
    var qid = 0
    var wenda = Wenda()
    var answers = [WendaAnswer]()
    
    private lazy var headerView: WendaAnswerHeaderView = {
        let headerView = WendaAnswerHeaderView.loadViewFromNib()
        return headerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.configuration()
        view.theme_backgroundColor = "colors.cellBackgroundColor"
        tableView._registerCell(cell: WendaAnswerCell.self)
        tableView.tableFooterView = UIView()
        
        qid = 6485873422990573838
        Network.loadProposeQuestionList(qid: qid, enterForm: "dongtai") { (wenda) in
            
            self.wenda = wenda
            
            self.answers = wenda.ans_list
            
            self.bottomView.modules = wenda.module_list
            
            self.headerView.question = wenda.question
            self.tableView.tableHeaderView = self.headerView
            
            self.tableView.reloadData()
        }
        
        //点击展开按钮
        headerView.didSelectUnfold = { [weak self] in
            self!.tableView.tableHeaderView = self!.headerView
        }
        
        //加载更多
        tableView.mj_footer = RefreshFooter(refreshingBlock: { [weak self] in
            Network.loadMoreProposeQuestionList(qid: self!.qid, enterForm: "dongtai", offset: self!.answers.count, completionHandler: { (wenda) in
                
                if (self!.tableView.mj_footer.isRefreshing) {
                    self!.tableView.mj_footer.endRefreshing()
                }
                self!.tableView.mj_footer.pullingPercent = 0.8
                if wenda.ans_list.count == 0 {
                    self!.tableView.mj_footer.endRefreshingWithNoMoreData()
                    SVProgressHUD.showInfo(withStatus: "没有更多数据啦！")
                    return
                }
                self!.answers += wenda.ans_list
                self!.tableView.reloadData()
            })
        })
        tableView.mj_footer.isAutomaticallyChangeAlpha = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
        
    }

}

extension WendaViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //tablecell重用机制和kf异步加载图片，缓存池重用导致数据错乱
        var cell = tableView.cellForRow(at: indexPath) as? WendaAnswerCell
        if cell == nil {
            cell = tableView._dequeueReusableCell(indexPath: indexPath) as WendaAnswerCell
            cell!.answer = answers[indexPath.row]
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return answers[indexPath.row].cellHeight!
    }
    
}
