//
//  MainTabBarController.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/4.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK:- 懒加载
    fileprivate lazy var imageNames = ["home", "message_center", "", "discover", "profile"]
    fileprivate lazy var composeBtn = UIButton.init(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
    
    // MARK:- 系统调用的方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupComposrBtn()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupItems()
    }
}

// MARK:- UI界面
extension MainTabBarController {
    /// 设置发布按钮
    fileprivate func setupComposrBtn() {
        // 设置位置
        composeBtn.center = CGPoint.init(x: tabBar.center.x, y: tabBar.frame.size.height * 0.5)
        // 添加到父控件
        tabBar.addSubview(composeBtn)
        // 监听发布按钮的点击
        composeBtn.addTarget(self, action:#selector(composeBtnClick), for: .touchUpInside)
    }
    
    /// 设置所有的item
    fileprivate func setupItems() {
        // 1.遍历所有的item
        for i in 0..<tabBar.items!.count{
            
            // 2.获取对应下标的item
            let item = tabBar.items![i]
            
            // 3.下标是2的item不与用户进行交互
            if i == 2 {
                item.isEnabled = false
            }
            // tabbar_discover_highlighted
            // 4.设置item选中时的图片
            item.selectedImage = UIImage.init(named: "tabbar_" + imageNames[i] + "_highlighted")
        }
    }
}

// MARK:- 监听事件
extension MainTabBarController {

    @objc fileprivate func composeBtnClick() {
        
        let composeViewController = UINavigationController.init(rootViewController: ComposeViewController())
        
        present(composeViewController, animated: true, completion: nil)
    }
}
