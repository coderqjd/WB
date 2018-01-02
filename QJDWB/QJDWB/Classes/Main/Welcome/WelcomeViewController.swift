//
//  WelcomeViewController.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/14.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {

    // MARK:- 控件属性
    @IBOutlet weak var iconViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置头像
        let urlString = UserAccountViewModel.shareInstance.userAccount?.avatar_large
        let url = URL.init(string: urlString ?? "")
        iconView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "avatar_default_big"))
        
        // 改变约束值
        iconViewBottomCons.constant = screenH - 200
        
        // 执行动画
        UIView.animate(withDuration: 3.0, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 4.0, options: [], animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            // 回到主界面
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
        }
    }

}
