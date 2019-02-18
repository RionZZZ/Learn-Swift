//
//  MoreLoginViewController.swift
//  News
//
//  Created by Rion on 2019/2/17.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import IBAnimatable

class MoreLoginViewController: AnimatableModalViewController {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var mobileView: AnimatableView!
    @IBOutlet weak var passwordView: AnimatableView!
    @IBOutlet weak var sendCaptcha: UIView!
    @IBOutlet weak var findPassword: UIView!
    @IBOutlet weak var sendCaptchaButton: UIButton!
    @IBOutlet weak var findPasswordButton: UIButton!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var enterButton: AnimatableButton!
    @IBOutlet weak var argeementLabel: UILabel!
    @IBOutlet weak var argeementButton: UIButton!
    @IBOutlet weak var loginModeButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var wechatButton: UIButton!
    @IBOutlet weak var qqButton: UIButton!
    @IBOutlet weak var tianyiButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginModeButton.setTitle("免密码登录", for: .selected)
        view.theme_backgroundColor = "colors.cellBackgroundColor"
        topLabel.theme_textColor = "colors.black"
        tipLabel.theme_textColor = "colors.cellRightTextColor"
        argeementLabel.theme_textColor = "colors.black"
        argeementButton.theme_setImage("images.agreementButton", forState: .selected)
        argeementButton.theme_setImage("images.agreementOKButton", forState: .normal)
        mobileView.theme_backgroundColor = "colors.loginFieldBackground"
        passwordView.theme_backgroundColor = "colors.loginFieldBackground"
        closeButton.theme_setImage("images.closeButton", forState: .normal)
        enterButton.theme_backgroundColor = "colors.enterBackgroundColor"
        enterButton.theme_setTitleColor("colors.enterTextColor", forState: .normal)
        wechatButton.theme_setImage("images.wechatButton", forState: .normal)
        qqButton.theme_setImage("images.QQButton", forState: .normal)
        tianyiButton.theme_setImage("images.tianyiButton", forState: .normal)
        mailButton.theme_setImage("images.mailButton", forState: .normal)
    }
    
    @IBAction func onCloseClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginModeClick(_ sender: UIButton) {
        loginModeButton.isSelected = !sender.isSelected
        sendCaptcha.isHidden = sender.isSelected
        findPassword.isHidden = !sender.isSelected
        tipLabel.isHidden = sender.isSelected
        passwordTextField.placeholder = sender.isSelected ? "请输入密码" : "请输入验证码"
        topLabel.text = sender.isSelected ? "账号密码登录" : "登录你的头条，精彩永不落幕"
    }
    
    @IBAction func argeementClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
}
