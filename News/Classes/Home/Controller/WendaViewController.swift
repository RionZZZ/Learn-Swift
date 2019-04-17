//
//  WendaViewController.swift
//  News
//
//  Created by Rion on 2019/4/12.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class WendaViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var bottomView: WendaAnswerBottomView!
    @IBOutlet weak var bottomViewBottom: NSLayoutConstraint!
    
    var wenda = Wenda()
    var answers = [WendaAnswer]()
    
    private lazy var headerView: WendaAnswerHeaderView = {
        let headerView = WendaAnswerHeaderView.loadViewFromNib()
        return headerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.theme_backgroundColor = "colors.cellBackgroundColor"
        tableView._registerCell(cell: WendaAnswerCell.self)
        answers = wenda.ans_list
        
        tableView.tableFooterView = UIView()
        
        bottomView.modules = wenda.module_list
        
        headerView.question = wenda.question
        tableView.tableHeaderView = headerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

}

extension WendaViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView._dequeueReusableCell(indexPath: indexPath) as WendaAnswerCell
        cell.answer = answers[indexPath.row]
        return cell
    }
    
    
}
