//
//  UserDetailDongtaiCell.swift
//  News
//
//  Created by Rion on 2019/2/25.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import IBAnimatable
import Kingfisher

class UserDetailDongtaiCell: UITableViewCell, RegisterCellOrNib {
    
    @IBOutlet weak var avatarImage: AnimatableImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var modifyTimeLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var contentLabel: RichLabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    @IBOutlet weak var allContent: UILabel!
    @IBOutlet weak var middleView: UIView!
    
    var didClickUserName: ((_ uid: Int) -> ())?
    var didClickTopic: ((_ cid: Int) -> ())?
    private let emojiManager = EmojiManager()
    var dongtai: UserDetailDongtai? {
        didSet {
            avatarImage.kf.setImage(with: URL(string: dongtai!.user.avatar_url))
            nameLabel.text = dongtai!.user.screen_name
            modifyTimeLabel.text = "· \(dongtai!.createTime)"
            likeButton.setTitle("\(dongtai!.commentCount)", for: .normal)
            forwardButton.setTitle("\(dongtai!.forwardCount)", for: .normal)
            bottomLabel.text = ("\(dongtai!.readCount)人阅读\(dongtai!.brand_info)")
            
//            contentLabel.text = dongtai!.content
            contentLabel.attributedText = emojiManager.emojiShow(content: dongtai!.content, font: contentLabel.font)
            
            contentLabel.userTapeed = {(userName, range) in
                for user in self.dongtai!.userContents! {
                    if user.name == userName {
                        //向上传递事件（闭包）
                        self.didClickUserName?(Int(user.uid)!)
                    }
                }
            }
            
            contentLabel.topicTapeed = {(topic, range) in
                for topicContent in self.dongtai!.userContents! {
                    if topic.contains(topicContent.name) {
                        self.didClickTopic?(Int(topicContent.uid)!)
                    }
                }
            }
            
            contentLabel.linkTapeed = {(link, range) in
                
            }
            
            
            contentHeight.constant = dongtai!.contentH
            allContent.isHidden = dongtai!.contentH != 110
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
            
            switch dongtai!.item_type {
            case .postVideoOrArticle, .postVideo, .answerQuestion, .proposeQuestion, .forwardArticle, .postContentAndVideo: //文章或视频
                middleView.addSubview(postVideoOrArticle)
                postVideoOrArticle.frame = CGRect(x: 15, y: 0, width: screenWidth - 30, height: middleView.height)
                if dongtai!.group.title == "" {
                    postVideoOrArticle.originGroup = dongtai!.origin_group
                } else {
                    postVideoOrArticle.group = dongtai!.group
                }
            case .postContent, .postSmallVideo: //文字内容
                middleView.addSubview(collectionView)
                collectionView.frame = CGRect(x: 15, y: 0, width: dongtai!.collectionViewW, height: dongtai!.collectionViewH)
                if dongtai!.item_type  == .postSmallVideo {
                    collectionView.isPostVideo = true
                }
                collectionView.thumbImageList = dongtai!.thumb_image_list
                collectionView.largeImages = dongtai!.large_image_list
            case .commentOrQuoteContent, .commentOrQuoteOthers: //引用或评论
                middleView.addSubview(originalThreadView)
                originalThreadView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: dongtai!.origin_thread.height)
                originalThreadView.originThread = dongtai!.origin_thread
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
//    private lazy var collectionView: UICollectionView = {
//        let collection = UICollectionView(frame: .zero, collectionViewLayout: DongtaiCollectionFlowLayout())
//        collection._registerCell(cell: DongtaiCollectionCell.self)
//        collection.delegate = self
//        collection.dataSource = self
//        collection.showsVerticalScrollIndicator = false
//        collection.showsHorizontalScrollIndicator = false
//        collection.isScrollEnabled = false
//        collection.theme_backgroundColor = "colors.cellBackgroundColor"
//        return collection
//    }()
    
    private lazy var originalThreadView: DongtaiOriginalThreadView = {
        let view = DongtaiOriginalThreadView.loadViewFromNib()
        return view
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.theme_textColor = "colors.black"
        likeButton.theme_setTitleColor("colors.black", forState: .normal)
        forwardButton.theme_setTitleColor("colors.black", forState: .normal)
        commentButton.theme_setTitleColor("colors.black", forState: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

//extension UserDetailDongtaiCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return dongtai!.thumb_image_list.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView._dequeueReusableCell(indexPath: indexPath) as DongtaiCollectionCell
//        cell.thumbImage = dongtai!.thumb_image_list[indexPath.item]
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return Calculate.collectionCellSize(dongtai!.thumb_image_list.count)
//    }
//    
//}


//class DongtaiCollectionFlowLayout: UICollectionViewFlowLayout {
//    override func prepare() {
//        super.prepare()
//        minimumLineSpacing = 5
//        minimumInteritemSpacing = 5
//    }
//}
