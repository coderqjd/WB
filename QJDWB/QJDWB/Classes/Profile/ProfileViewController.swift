//
//  ProfileViewController.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/4.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        visitorView.setupVisitorViewInfo(iconName: "visitordiscover_image_profile", title: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
    }

}
