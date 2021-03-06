//
//  UserDetailHeaderView.swift
//  News
//
//  Created by Rion on 2019/2/19.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import IBAnimatable
import Kingfisher
import SVProgressHUD

class UserDetailHeaderView: UIView, NibLoadable {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var backgroundTop: NSLayoutConstraint!
    @IBOutlet weak var avatorImage: AnimatableImageView!
    @IBOutlet weak var vipImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var toutiaoImage: UIImageView!
    @IBOutlet weak var sendMail: UIButton!
    @IBOutlet weak var concernButton: AnimatableButton!
    @IBOutlet weak var recommandButton: AnimatableButton!
    @IBOutlet weak var recommandWidth: NSLayoutConstraint!
    @IBOutlet weak var recommandTrailing: NSLayoutConstraint!
    @IBOutlet weak var recommandView: UIView!
    @IBOutlet weak var recommandViewHeight: NSLayoutConstraint!
    @IBOutlet weak var verifiedAgencyLabel: UILabel!
    @IBOutlet weak var verifiedAgencyLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var verifiedAgencyLabelTop: NSLayoutConstraint!
    @IBOutlet weak var verifiedContentLabel: UILabel!
    @IBOutlet weak var areaButton: UIButton!
    @IBOutlet weak var areaButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var areaButtonTop: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var unfoldButton: UIButton!
    @IBOutlet weak var unfoldButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var unfoldButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var followingsCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var topTabView: UIView!
    @IBOutlet weak var topTabHeight: NSLayoutConstraint!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var bottomScrollView: UIScrollView!
    
    var didClickUserUid: ((_ uid: Int) -> ())?
    var didClickTopicCid: ((_ cid: Int) -> ())?
    var didSelectCell: ((_ dongtai: UserDetailDongtai) -> ())?
    
    var previousButton = UIButton()
    lazy var indicatorView: UIView = {
        let indicatorView = UIView(frame: CGRect(x: (topTabButtonWidth - topTabindicatorWidth) * 0.5, y: topTabView.height - 2, width: topTabindicatorWidth, height: topTabindicatorHeight))
        indicatorView.theme_backgroundColor = "colors.globalRedColor"
        return indicatorView
    }()
    
    var userDetail: UserDetail? {
        didSet {
            backgroundImage.kf.setImage(with: URL(string: userDetail!.bg_img_url))
            avatorImage.kf.setImage(with: URL(string: userDetail!.avatar_url))
            vipImage.isHidden = !userDetail!.user_verified
            nameLabel.text = userDetail!.screen_name
            if userDetail!.verified_agency == "" {
                verifiedAgencyLabelHeight.constant = 0
                verifiedAgencyLabelTop.constant = 0
            } else {
                verifiedAgencyLabel.text = userDetail!.verified_agency + "："
                verifiedContentLabel.text = userDetail!.verified_content
            }
            concernButton.isSelected = userDetail!.is_following
            if userDetail!.area == "" {
                areaButton.isHidden = true
                areaButtonHeight.constant = 0
                areaButtonTop.constant = 0
            } else {
                areaButton.setTitle(userDetail!.area, for: .normal)
            }
            descriptionLabel.text = userDetail!.description as String
            if userDetail!.descriptionHeight! > 21 {
                unfoldButton.isHidden = false
                unfoldButtonWidth.constant = 40
            }
            recommandWidth.constant = 0
            recommandTrailing.constant = 15
            followersCountLabel.text = userDetail!.followersCount
            followingsCountLabel.text = userDetail!.followingsCount
            if userDetail!.top_tab.count > 0 {
                //添加按钮和tabview
                for (index, value) in userDetail!.top_tab.enumerated() {
                    let button = UIButton(frame: CGRect(x: CGFloat(index) * topTabButtonWidth, y: 0, width: topTabButtonWidth, height: scrollView.height))
                    button.tag = index
                    button.setTitle(value.show_name, for: .normal)
                    button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                    button.theme_setTitleColor("colors.black", forState: .normal)
                    button.theme_setTitleColor("colors.globalRedColor", forState: .selected)
                    button.addTarget(self, action: #selector(topTabButtonClick), for: .touchUpInside)
                    scrollView.addSubview(button)
                    if index == 0 {
                        button.isSelected = true
                        previousButton = button
                    }
                    
                    //tabview
                    let tabview = UITableView(frame: CGRect(x: CGFloat(index) * screenWidth, y: 0, width: screenWidth, height: bottomScrollView.height))
//                    if value.type == .wenda {
                        tabview._registerCell(cell: UserDetailWendaCell.self)
//                    } else {
                        tabview._registerCell(cell: UserDetailDongtaiCell.self)
//                    }
                    
                    if value.type == .wenda {
                        //加载问答数据
                        Network.loadUserDetailWenDaList(userId: self.userDetail!.user_id, cursor: self.wendaCursor) { (cursor, wendas) in
                            self.wendas = wendas
                            self.wendaCursor = cursor
                        }
                    }
                    if userDetail!.bottom_tab.count == 0 {
                        tabview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: safeAreaBottom!, right: 0)
                    }
                    tabview.delegate = self
                    tabview.dataSource = self
//                    tabview.rowHeight = 130
                    tabview.isScrollEnabled = false
                    tabview.showsVerticalScrollIndicator = false
                    tabview.separatorStyle = .none
                    tabview.tableFooterView = UIView()
                    bottomScrollView.addSubview(tabview)
                    
                    if index == userDetail!.top_tab.count - 1 {
                        scrollView.contentSize = CGSize(width: button.frame.maxX, height: scrollView.height)
                        bottomScrollView.contentSize = CGSize(width: tabview.frame.maxX, height: bottomScrollView.height)
                    }
                }
                scrollView.addSubview(indicatorView)
            } else {
                topTabHeight.constant = 0
                topTabView.isHidden = true
            }
            layoutIfNeeded()
        }
    }
    
    //推荐列表
    lazy var relationRecommand: RelationRecommandView = {
        let relationRecommand = RelationRecommandView.loadViewFromNib()
        return relationRecommand
    }()
    
    //动态数据列表
//    var dongtais = [UserDetailDongtai]() {
//        didSet {
//            if bottomScrollView.subviews.count > 0 {
//                let tabview = bottomScrollView.subviews[0] as! UITableView
//                tabview.reloadData()
//            }
//        }
//    }
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
    //当前toptab的类型和索引
    var currentTopTabIndex = 0
    var currentTopTabType: TopTabType = .dongtai {
        didSet {
            let tableview = bottomScrollView.subviews[currentTopTabIndex] as! UITableView
            switch currentTopTabType {
            case .dongtai:
                setupFooter(tableview) { (dongtais) in
                    self.dongtais += dongtais
                    tableview.reloadData()
                }
                if !isDongtaisShown {
                    isDongtaisShown = true
                    tableview.reloadData()
                }
            case .article:
                setupFooter(tableview) { (dongtais) in
                    self.articles += dongtais
                    tableview.reloadData()
                }
                if !isArticlesShown {
                    isArticlesShown = true
                    tableview.mj_footer.beginRefreshing()
                }
            case .video:
                setupFooter(tableview) { (dongtais) in
                    self.videos += dongtais
                    tableview.reloadData()
                }
                if !isVideosShown {
                    isVideosShown = true
                    tableview.mj_footer.beginRefreshing()
                }
            case .wenda:
                if !isWendasShown {
                    isWendasShown = true
                    tableview.reloadData()
                }
            case .iesVideo:
                setupFooter(tableview) { (dongtais) in
                    self.iesVideos += dongtais
                    tableview.reloadData()
                }
                if !isIesVideosShown {
                    isIesVideosShown = true
                    tableview.mj_footer.beginRefreshing()
                }
            }
        }
    }
    
    private func setupFooter(_ tableview: UITableView, completionHandler:@escaping ((_ datas: [UserDetailDongtai])->())) {
        tableview.mj_footer = RefreshFooter(refreshingBlock: { [weak self] in
            Network.loadUserDetailDongtaiList(userId: self!.userDetail!.user_id, maxCursor: self!.maxCursor, completionHandler: { (cursor, dongtais) in
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundTop.constant = -statusBarHeight
        concernButton.setTitle("关注", for: .normal)
        concernButton.setTitle("已关注", for: .selected)
        
        SVProgressHUD.configuration()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //解决样式bug
        width = screenWidth
        for subview in bottomScrollView.subviews {
            let tableview = subview as! UITableView
            tableview.height = bottomScrollView.height
        }
    }
    
//    class func headerView() -> UserDetailHeaderView {
//        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.last as! UserDetailHeaderView
//    }
    
    @IBAction func sendMailClick(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: String(describing: MoreLoginViewController.self), bundle: nil)
        let moreLoginVC = storyboard.instantiateViewController(withIdentifier: String(describing: MoreLoginViewController.self)) as! MoreLoginViewController
        moreLoginVC.modalSize = (width: .full, height: .custom(size: Float(screenHeight - statusBarHeight)))
        UIApplication.shared.keyWindow?.rootViewController?.present(moreLoginVC, animated: true, completion: nil)
    }
    
    @IBAction func concernButtonClick(_ sender: AnimatableButton) {
        if sender.isSelected {
            //已经关注，要取消关注
            Network.relationUnfollow(user_id: userDetail!.user_id) { (_) in
                sender.isSelected = !sender.isSelected
                self.recommandButton.isHidden = true
                self.recommandWidth.constant = 0
                self.recommandButton.isSelected = false
//                self.recommandTrailing.constant = 0
                self.recommandViewHeight.constant = 0
                UIView.animate(withDuration: 0.25, animations: {
                    self.recommandButton.imageView?.transform = .identity
                    self.layoutIfNeeded()
                }, completion: { (_) in
//                    self.resetLayout()
                })
            }
        } else {
            //还未关注，要关注
            Network.relationFollow(user_id: userDetail!.user_id) { (_) in
                sender.isSelected = !sender.isSelected
                self.recommandButton.isHidden = false
                self.recommandWidth.constant = 28
                self.recommandButton.isSelected = false
//                self.recommandTrailing.constant = 15
                self.recommandViewHeight.constant = 230
                UIView.animate(withDuration: 0.25, animations: {
                    self.layoutIfNeeded()
                }, completion: { (_) in
//                    self.resetLayout()
                    Network.loadRelationUserRecommand(user_id: self.userDetail!.user_id, completionHandler: { (userCards) in
                        self.recommandView.addSubview(self.relationRecommand)
                        self.relationRecommand.userCards = userCards
                    })
                })
            }
        }
    }
    
    @IBAction func recommandButtonClick(_ sender: AnimatableButton) {
        sender.isSelected = !sender.isSelected
        recommandViewHeight.constant = sender.isSelected ? 0 : 230
        relationRecommand.labelHeight.constant = sender.isSelected ? 0 : 32
        UIView.animate(withDuration: 0.25, animations: {
            sender.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(sender.isSelected ? Double.pi : 0))
            self.layoutIfNeeded()
        }) { (_) in
//            self.resetLayout()
        }
    }
    
    @IBAction func unflodButtonClick(_ sender: UIButton) {
        unfoldButton.isHidden = true
        unfoldButtonWidth.constant = 0
        descriptionLabelHeight.constant = userDetail!.descriptionHeight!
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
        }) { (_) in
//            self.resetLayout()
        }
    }
    
//    private func resetLayout() {
//        baseView.height = topTabView.frame.maxY
//        height = baseView.frame.maxY
//    }
    
    @objc func topTabButtonClick(button: UIButton) {
        previousButton.isSelected = false
        button.isSelected = !button.isSelected
        UIView.animate(withDuration: 0.25, animations: {
            self.indicatorView.centerX = button.centerX
            self.bottomScrollView.contentOffset = CGPoint(x: CGFloat(button.tag) * screenWidth, y: 0)
        }) { (_) in
            self.previousButton = button
        }
        
        currentTopTabIndex = button.tag
        currentTopTabType = userDetail!.top_tab[button.tag].type
    }
    
}

extension UserDetailHeaderView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dongtais.count
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    //滑到顶部时，禁止tableview滚动，启用页面滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            for subview in bottomScrollView.subviews {
                let tableview = subview as! UITableView
                tableview.isScrollEnabled = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch currentTopTabType {
        case .dongtai:   // 动态
            let dongtai = dongtais[indexPath.row]
            didSelectCell?(dongtai)
        case .article:   // 文章
            let dongtai = articles[indexPath.row]
            didSelectCell?(dongtai)
        case .video:     // 视频
            let dongtai = videos[indexPath.row]
            didSelectCell?(dongtai)
        case .wenda:     // 问答
            print("")
        case .iesVideo:  // 小视频
            let dongtai = iesVideos[indexPath.row]
            didSelectCell?(dongtai)
        }
    }
    
}
