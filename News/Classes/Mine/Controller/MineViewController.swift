//
//  MineViewController.swift
//  News
//
//  Created by Rion on 2019/2/14.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MineViewController: UITableViewController {

    var sections = [[MineCellModel]]()
    var concerns = [MineConcernModel]()
    
    fileprivate lazy var headerView: NoLoginHeaderView = {
//        let headerView = NoLoginHeaderView.headerView()
        let headerView = NoLoginHeaderView.loadViewFromNib()
        return headerView
    }()
    
    fileprivate let disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: false)
//    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
//        tableView.backgroundColor = UIColor.globalBgc()
        tableView.theme_backgroundColor = "colors.tableViewBackgroundColor"
        tableView.separatorStyle = .none
        tableView._registerCell(cell: MineFirstSectionCell.self)
        tableView._registerCell(cell: MineOtherCell.self)
//        tableView.register(UINib(nibName: String(describing : MineOtherCell.self), bundle: nil), forCellReuseIdentifier: String(describing : MineOtherCell.self))
//        tableView.register(UINib(nibName: String(describing : MineFirstSectionCell.self), bundle: nil), forCellReuseIdentifier: String(describing : MineFirstSectionCell.self))
        
        //获取cell数据
        Network.loadMineCellData { sections in
            let str = "{\"text\":\"我的关注\",\"grey_text\":\"\"}"
            let mineConcern = MineCellModel.deserialize(from: str)
            var mineConcerns = [MineCellModel]()
            mineConcerns.append(mineConcern!)
            self.sections.append(mineConcerns)
            self.sections += sections
            self.tableView.reloadData()
            
            //获取concern数据
            Network.loadMineConcern { concerns in
                self.concerns = concerns
                let index = IndexSet(integer: 0)
                self.tableView.reloadSections(index, with: .automatic)
            }
        }
        
        headerView.moreLogin.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] in
                let storyboard = UIStoryboard(name: String(describing: MoreLoginViewController.self), bundle: nil)
                let moreLoginVC = storyboard.instantiateViewController(withIdentifier: String(describing: MoreLoginViewController.self)) as! MoreLoginViewController
                moreLoginVC.modalSize = (width: .full, height: .custom(size: Float(screenHeight - statusBarHeight)))
                self!.present(moreLoginVC, animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
    
}

extension MineViewController {
    //每组头部高度
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 0 : 10
    }
    //头部视图
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 10))
//        view.backgroundColor = UIColor.globalBgc()
        view.theme_backgroundColor = "colors.tableViewBackgroundColor"
        return view
    }
    //cell高度
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return (concerns.count == 0 || concerns.count == 1) ? 44 : 118
        }
        return 44
    }
    
    //组数
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    //cell数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    //cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView._dequeueReusableCell(indexPath: indexPath) as MineFirstSectionCell
//            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing : MineFirstSectionCell.self)) as! MineFirstSectionCell
            
            let section = sections[indexPath.section]
            cell.mineCell = section[indexPath.row]
//            let mineCellModel = section[indexPath.row]
//            cell.leftLabel.text = mineCellModel.text
//            cell.rightLabel.text = mineCellModel.grey_text
            if concerns.count == 0 || concerns.count == 1 {
                cell.collectionView.isHidden = true
            }
            if concerns.count == 1 {
                cell.mineConcern = concerns[0]
            }
            if concerns.count > 1 {
                cell.concerns = concerns
            }
//            cell.delegate = self
            cell.mineConcernSelected = { (concernCell) in
                if concernCell.userid != nil {
//                    let userDetailVC = UserDetailViewController()
                    let userDetailVC = UserDetailViewController2()
                    userDetailVC.userId = concernCell.userid!
                    self.navigationController?.pushViewController(userDetailVC, animated: true)
                }
            }
            return cell
        }
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let cell = tableView._dequeueReusableCell(indexPath: indexPath) as MineOtherCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing : MineOtherCell.self)) as! MineOtherCell
        let section = sections[indexPath.section]
        let mineCellModel = section[indexPath.row]
//        cell.textLabel?.text = mineCellModel.text
        cell.leftLabel.text = mineCellModel.text
        cell.rightLabel.text = mineCellModel.grey_text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 3 && indexPath.row == 1 {
            //系统设置界面
            let settingVC = SettingViewController()
            settingVC.navigationItem.title = "设置"
            navigationController?.pushViewController(settingVC, animated: true)
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            let totalOffset = MineHeaderHeight + abs(offsetY)
            let f = totalOffset / MineHeaderHeight
            headerView.backgroundImage.frame = CGRect(x: -screenWidth * (f - 1), y: offsetY, width: screenWidth * f, height: totalOffset)
        }
    }
}

//extension MineViewController: MineFirstSectionCellDelegate {
//    func MineFirstSectionCell(_ firstCell: MineFirstSectionCell, mineConcern: MineConcernModel) {
//        let userDetailVC = UserDetailViewController()
//        navigationController?.pushViewController(userDetailVC, animated: true)
//    }
//
//}
