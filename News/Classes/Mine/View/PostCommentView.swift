//
//  PostCommentView.swift
//  News
//
//  Created by Rion on 2019/4/13.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import IBAnimatable

class PostCommentView: UIView, NibLoadable {
    
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var atButton: UIButton!
    @IBOutlet weak var emojiButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var textViewBackground: AnimatableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeholderView: UILabel!
    @IBOutlet weak var viewBottom: NSLayoutConstraint!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var leftEmojiButton: UIButton!
    @IBOutlet weak var leftEmojiHeight: NSLayoutConstraint!
    @IBOutlet weak var pageControllerView: UIView!
    @IBOutlet weak var emojiView: UIView!
    @IBOutlet weak var emojiViewBottom: NSLayoutConstraint!
    @IBOutlet weak var emojiViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var pageControl: UIPageControl = {
       let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = UIColor.init(r: 200, g: 200, b: 200)
        pageControl.currentPageIndicatorTintColor = UIColor.init(r: 100, g: 100, b: 100)
        return pageControl
    }()
    
    let emojiManager = EmojiManager()
    
    //是否点击emoji按钮
    var isEmoji = false {
        didSet {
            emojiButton.isSelected = isEmoji
            if isEmoji {
                UIView.animate(withDuration: 0.25) {
                    self.changeConstraints()
                    self.viewBottom.constant = 60 + emojiWidth * 3
                    self.layoutIfNeeded()
                }
                
                if pageControllerView.subviews.count == 0 {
                    pageControl.numberOfPages = emojiManager.emojis.count / 21
                    pageControl.center = pageControllerView.center
                    pageControllerView.addSubview(pageControl)
                }
            } else {
                textView.becomeFirstResponder()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        width = screenWidth
        height = screenHeight
        
        forwardButton.theme_setImage("images.agreementButton", forState: .normal)
        forwardButton.theme_setImage("images.agreementOKButton", forState: .selected)
        forwardButton.isSelected = true
        
        emojiButton.setImage(UIImage(named: "toolbar_icon_emoji_24x24_"), for: .normal)
        emojiButton.setImage(UIImage(named: "toolbar_icon_keyboard_24x24_"), for: .selected)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        collectionView._registerCell(cell: EmojiCollectionCell.self)
        collectionView.collectionViewLayout = EmojiLayout()
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let frame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: duration) {
            
            self.changeConstraints()
            //输入预测高度 42, iphonex - 333 / 291, 其他 216
//            添加到window上时，不需要减去57来计算
//            self.viewBottom.constant = frame.size.height - (isBigPhone ? 57 : 0)
            self.viewBottom.constant = frame.size.height
            self.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: duration) {
            self.resetConstraints()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
        if isEmoji {
            UIView.animate(withDuration: 0.25, animations: {
                self.resetConstraints()
            }) { (_) in
                self.removeFromSuperview()
            }
        } else {
            removeFromSuperview()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func onForwardClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func onAtClick(_ sender: Any) {
    }
    
    @IBAction func onEmojiClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            textView.resignFirstResponder()
            isEmoji = true
        } else {
            textView.becomeFirstResponder()
        }
    }
    
    //改变约束
    func changeConstraints() {
        leftEmojiHeight.constant = 40
        emojiViewHeight.constant = 60
//        emojiViewBottom.constant = safeAreaBottom!
    }
    
    //重置约束
    func resetConstraints() {
        leftEmojiHeight.constant = 0
        emojiViewHeight.constant = 0
        viewBottom.constant = 0
        layoutIfNeeded()
    }
}

extension PostCommentView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderView.isHidden = textView.text.count != 0
        postButton.setTitleColor(textView.text.count != 0 ? .blueFontColor() : .grayColor210(), for: .normal)
        let height = Calculate.attributedTextHeight(text: textView.attributedText, width: textView.width)
        if height <= 30 {
            textViewHeight.constant = 30
        } else if height >= 80 {
            textViewHeight.constant = 80
        } else {
            textViewHeight.constant = height
        }
        layoutIfNeeded()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        emojiButton.isSelected = false
        return true
    }
}

extension PostCommentView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiManager.emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView._dequeueReusableCell(indexPath: indexPath) as EmojiCollectionCell
        cell.emoji = emojiManager.emojis[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoji = emojiManager.emojis[indexPath.item]
        textView.setAttributedText(emoji: emoji)
        placeholderView.isHidden = textView.attributedText.length != 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = scrollView.contentOffset.x / scrollView.width
        pageControl.currentPage = Int(currentPage + 0.5)
    }
    
}
