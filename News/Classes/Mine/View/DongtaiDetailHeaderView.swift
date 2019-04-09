//
//  DongtaiDetailHeaderView.swift
//  News
//
//  Created by Rion on 2019/4/8.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import IBAnimatable
import Kingfisher

class DongtaiDetailHeaderView: UIView, NibLoadable {
    
    @IBOutlet weak var avatatButton: AnimatableButton!
    @IBOutlet weak var vipImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var readCountLabel: UILabel!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var contentLabel: RichLabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var zanButton: UIButton!
    
    private let emojiManager = EmojiManager()
    var didClickUserName: ((_ uid: Int) -> ())?
    var didClickTopic: ((_ cid: Int) -> ())?
    var dongtai = UserDetailDongtai() {
        didSet {
            avatatButton.kf.setImage(with: URL(string: dongtai.user.avatar_url), for: .normal)
            nameLabel.text = dongtai.user.screen_name
            timeLabel.text = "· \(dongtai.createTime)"
            infoLabel.text = dongtai.user.verified_content
            readCountLabel.text = "\(dongtai.readCount)阅读 · \(dongtai.brand_info) \(dongtai.position.position)"
            commentCountLabel.text = "\(dongtai.commentCount)人评论"
            zanButton.setTitle(dongtai.diggCount, for: .normal)
            
            contentLabel.attributedText = emojiManager.emojiShow(content: dongtai.content, font: contentLabel.font)
            
            contentLabel.userTapeed = {(userName, range) in
                for user in self.dongtai.userContents! {
                    if user.name == userName {
                        //向上传递事件（闭包）
                        self.didClickUserName?(Int(user.uid)!)
                    }
                }
            }
            
            contentLabel.topicTapeed = {(topic, range) in
                for topicContent in self.dongtai.userContents! {
                    if topic.contains(topicContent.name) {
                        self.didClickTopic?(Int(topicContent.uid)!)
                    }
                }
            }
            
            contentLabel.linkTapeed = {(link, range) in
                
            }
            
            //防止cell重用机制，导致数据错乱
            if middleView.contains(postVideoOrArticle) {
                postVideoOrArticle.removeFromSuperview()
            }
            if middleView.contains(collectionView) {
                collectionView.removeFromSuperview()
            }
            if middleView.contains(originalThreadView) {
                originalThreadView.removeFromSuperview()
            }
            
            switch dongtai.item_type {
            case .postVideoOrArticle, .postVideo, .answerQuestion, .proposeQuestion, .forwardArticle, .postContentAndVideo: //文章或视频
                middleView.addSubview(postVideoOrArticle)
                postVideoOrArticle.frame = CGRect(x: 15, y: 0, width: screenWidth - 30, height: middleView.height)
                if dongtai.group.title == "" {
                    postVideoOrArticle.originGroup = dongtai.origin_group
                } else {
                    postVideoOrArticle.group = dongtai.group
                }
            case .postContent, .postSmallVideo: //文字内容
                middleView.addSubview(collectionView)
                collectionView.isDongtaiDetail = true
                collectionView.frame = CGRect(x: 15, y: 0, width: dongtai.collectionViewW, height: dongtai.detailConllectionViewH)
                collectionView.isPostVideo = dongtai.item_type == .postSmallVideo
                collectionView.thumbImageList = dongtai.thumb_image_list
                collectionView.largeImages = dongtai.large_image_list
            case .commentOrQuoteContent, .commentOrQuoteOthers: //引用或评论
                middleView.addSubview(originalThreadView)
                originalThreadView.originThread!.isDongtaiDetail = true
                originalThreadView.frame = CGRect(x: 0, y: 0, width: screenWidth - 30, height: dongtai.origin_thread.height)
                originalThreadView.originThread = dongtai.origin_thread
            }
        }
    }
    
    private lazy var postVideoOrArticle: PostVideoOrArticleView = {
        let view = PostVideoOrArticleView.loadViewFromNib()
        return view
    }()
    
    private lazy var collectionView: DongtaiCollectionView = {
        let collection = DongtaiCollectionView.loadViewFromNib()
        return collection
    }()
    
    private lazy var originalThreadView: DongtaiOriginalThreadView = {
        let view = DongtaiOriginalThreadView.loadViewFromNib()
        return view
    }()
    
    var didClickCover: ((_ uid: Int) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        height = dongtai.detailHeaderHeight
    }

    @IBAction func onCoverClick(_ sender: UIButton) {
        didClickCover?(dongtai.user.user_id)
    }
}
