//
//  BaseViewController.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/4.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {
    
    // MARK:- 属性
    var isLogin : Bool = UserAccountViewModel.shareInstance.isLogin
    
    // MARK:- 懒加载属性
    lazy var visitorView : VisitorView = VisitorView.visitView()
    
    // MARK:- 系统回调方法
    override func loadView() {
        
        // 判断是否加载访客视图
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
    }
}

// MARK:- UI界面
extension BaseViewController {
    /// 设置访客视图
    fileprivate func setupVisitorView() {
        view = visitorView
        
        // 监听访客视图中”注册“和”登录“按钮的点击
        visitorView.registBtn.addTarget(self, action: #selector(registBtnClick), for: .touchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
    }
    
    /// 设置导航栏item
    fileprivate func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "注册", style: .plain, target: self, action: #selector(registBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "登录", style: .plain, target: self, action: #selector(loginBtnClick))
    }
}

// MARK:-  事件监听
extension BaseViewController {

    @objc fileprivate func registBtnClick() {
        
        
    }
    
    @objc fileprivate func loginBtnClick() {
        
        // 创建授权控制器
        let oauthVc = OAuthViewController()
        
        // 包装导航控制器
        let oauthNav = UINavigationController.init(rootViewController: oauthVc)
        
        // 弹出控制器
        present(oauthNav, animated: true, completion: nil)
    }
}
