//
//  DongtaiTableViewController.swift
//  News
//
//  Created by Rion on 2019/4/11.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import SVProgressHUD

class DongtaiTableViewController: UITableViewController {
    
    var userId = 0
    //当前topTab类型
    var currentTopTabType: TopTabType = .dongtai {
        didSet {
            switch currentTopTabType {
            case .dongtai:
                if !isDongtaisShown {
                    isDongtaisShown = true
                    setupFooter(tableView) { (dongtais) in
                        self.dongtais += dongtais
                        self.tableView.reloadData()
                    }
                    tableView.reloadData()
                    tableView.mj_footer.beginRefreshing()
                }
            case .article:
                if !isArticlesShown {
                    isArticlesShown = true
                    setupFooter(tableView) { (dongtais) in
                        self.articles += dongtais
                        self.tableView.reloadData()
                    }
                    tableView.mj_footer.beginRefreshing()
                }
            case .video:
                if !isVideosShown {
                    isVideosShown = true
                    setupFooter(tableView) { (dongtais) in
                        self.videos += dongtais
                        self.tableView.reloadData()
                    }
                    tableView.mj_footer.beginRefreshing()
                }
            case .wenda:
                if !isWendasShown {
                    isWendasShown = true
                    tableView.mj_footer = RefreshFooter(refreshingBlock: { [weak self] in
                        // 获取用户详情的问答列表更多数据
                        Network.loadUserDetailWenDaList(userId:  self!.userId, cursor: self!.wendaCursor, completionHandler: {
                            if self!.tableView.mj_footer.isRefreshing { self!.tableView.mj_footer.endRefreshing() }
                            self!.tableView.mj_footer.pullingPercent = 0.0
                            if $1.count == 0 {
                                self!.tableView.mj_footer.endRefreshingWithNoMoreData()
                                SVProgressHUD.showInfo(withStatus: "没有更多数据啦!")
                                return
                            }
                            self!.wendaCursor = $0
                            self!.wendas += $1
                            self!.tableView.reloadData()
                        })
                    })
                    tableView.mj_footer.beginRefreshing()
                }
            case .iesVideo:
                if !isIesVideosShown {
                    isIesVideosShown = true
                    setupFooter(tableView) { (dongtais) in
                        self.iesVideos += dongtais
                        self.tableView.reloadData()
                    }
                    tableView.mj_footer.beginRefreshing()
                }
            }
        }
    }
    
    var didClickUserUid: ((_ uid: Int) -> ())?
    var didClickTopicCid: ((_ cid: Int) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.configuration()
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: CGFloat(safeAreaBottom!), right: 0)
        tableView.theme_backgroundColor = "colors.cellBackgroundColor"
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.bouncesZoom = false
        
        tableView._registerCell(cell: UserDetailWendaCell.self)
        tableView._registerCell(cell: UserDetailDongtaiCell.self)
        
    }
    
    private func setupFooter(_ tableview: UITableView, completionHandler:@escaping ((_ datas: [UserDetailDongtai])->())) {
        tableview.mj_footer = RefreshFooter(refreshingBlock: { [weak self] in
            Network.loadUserDetailDongtaiList(userId: self!.userId, maxCursor: self!.maxCursor, completionHandler: { (cursor, dongtais) in
                if tableview.mj_footer.isRefreshing {
                    tableview.mj_footer.endRefreshing()
                }
                tableview.mj_footer.pullingPercent = 0
                if dongtais.count == 0 {
                    tableview.mj_footer.endRefreshingWithNoMoreData()
                    SVProgressHUD.showInfo(withStatus: "没有更多数据")
                    return
                }
                self!.maxCursor = cursor
                completionHandler(dongtais)
            })
        })
    }
    
    var dongtais = [UserDetailDongtai]()
    var articles = [UserDetailDongtai]()
    var videos = [UserDetailDongtai]()
    var wendas = [UserDetailWenda]()
    var iesVideos = [UserDetailDongtai]()
    
    // 刷新的指示器
    var maxCursor = 0
    var wendaCursor = ""
    /// 记录当前的数据是否刷新过
    var isDongtaisShown = false
    var isArticlesShown = false
    var isVideosShown = false
    var isWendasShown = false
    var isIesVideosShown = false

}

extension DongtaiTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentTopTabType {
        case .dongtai:   // 动态
            return dongtais.count
        case .article:   // 文章
            return articles.count
        case .video:     // 视频
            return videos.count
        case .wenda:     // 问答
            return wendas.count
        case .iesVideo:  // 小视频
            return iesVideos.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentTopTabType {
        case .dongtai:   // 动态
            return cellFor(tableView, at: indexPath, with: dongtais)
        case .article:   // 文章
            return cellFor(tableView, at: indexPath, with: articles)
        case .video:     // 视频
            return cellFor(tableView, at: indexPath, with: videos)
        case .wenda:     // 问答
            let cell = tableView._dequeueReusableCell(indexPath: indexPath) as UserDetailWendaCell
            cell.wenda = wendas[indexPath.row]
            return cell
        case .iesVideo:  // 小视频
            return cellFor(tableView, at: indexPath, with: iesVideos)
        }
    }
    
    private func cellFor(_ tableView: UITableView, at indexPath: IndexPath, with datas: [UserDetailDongtai]) -> UserDetailDongtaiCell {
        let cell = tableView._dequeueReusableCell(indexPath: indexPath) as UserDetailDongtaiCell
        cell.dongtai = datas[indexPath.row]
        cell.didClickUserName = { [weak self] uid in
            //向上传递事件（闭包）
            self!.didClickUserUid?(uid)
        }
        cell.didClickTopic = { [weak self] cid in
            //向上传递事件（闭包）
            self!.didClickTopicCid?(cid)
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch currentTopTabType {
        case .dongtai:   // 动态
            return cellHeight(with: dongtais[indexPath.row])
        case .article:   // 文章
            return cellHeight(with: articles[indexPath.row])
        case .video:     // 视频
            return cellHeight(with: videos[indexPath.row])
        case .wenda:     // 问答
            let wenda = wendas[indexPath.row]
            return wenda.cellHeight
        case .iesVideo:  // 小视频
            return cellHeight(with: iesVideos[indexPath.row])
        }
    }
    
    private func cellHeight(with data: UserDetailDongtai) -> CGFloat {
        return data.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch currentTopTabType {
        case .dongtai:   // 动态
            let dongtai = dongtais[indexPath.row]
            pushDetailController(dongtai)
        case .article:   // 文章
            let dongtai = articles[indexPath.row]
            pushDetailController(dongtai)
        case .video:     // 视频
            let dongtai = videos[indexPath.row]
            pushDetailController(dongtai)
        case .wenda:     // 问答
            print("wenda")
        case .iesVideo:  // 小视频
            let dongtai = iesVideos[indexPath.row]
            pushDetailController(dongtai)
        }
    }
    
    func pushDetailController(_ dongtai: UserDetailDongtai) {
        switch dongtai.item_type {
        case .commentOrQuoteOthers, .commentOrQuoteContent, .forwardArticle, .postContent:
            let dongtaiVC = DongtaiDetailController()
            dongtaiVC.dongtai = dongtai
            navigationController?.pushViewController(dongtaiVC, animated: true)
        case .postVideo, .postVideoOrArticle, .postContentAndVideo:
            print("跳转视频播放器")
        case .proposeQuestion:
            let wendaVC = WendaViewController()
            navigationController?.pushViewController(wendaVC, animated: true)
        case .answerQuestion:
            print("回答")
        case .postSmallVideo:
            print("小视频")
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offetY = scrollView.contentOffset.y
        if offetY <= 0 {
            tableView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
}
