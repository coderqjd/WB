//
//  OAuthViewController.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/10.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    // MARK:- 控件属性
    @IBOutlet weak var webView: UIWebView!
    // MARK:- 系统调用方法
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupNavgationItem()
        
        // 加载登录页面
        loadPage()
        
        SVProgressHUD.show()
    }
}

// MARK:- UI界面
extension OAuthViewController {
    fileprivate func setupNavgationItem() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(backItemClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "填充", style: .plain, target: self
            , action: #selector(fillItemClick))
        
        title = "登录界面"
    }
    
    fileprivate func loadPage() {
        
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        
        webView.loadRequest(URLRequest.init(url: URL.init(string: urlString)!))
        
    }
}

// MARK:- 监听事件
extension OAuthViewController {

    @objc fileprivate func backItemClick() {
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func fillItemClick() {
        // js代码
        let jscode = "document.getElementById('userId').value='915723614@qq.com'; document.getElementById('passwd').value='15605662267wb';"
        // 执行js代码
        webView.stringByEvaluatingJavaScript(from: jscode)
    }
}

// MARK:- 代理方法
extension OAuthViewController : UIWebViewDelegate{

    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 1.获取加载网页的url
        guard let url = request.url else {
            return true
        }
        
        // 2.获取url的字符串
        let urlStr = url.absoluteString
        
        // 3.判断urlstr是否包含“code=”
        guard urlStr.contains("code=") else {
            return true
        }
        
        // 4.取出code
        let code = urlStr.components(separatedBy: "code=").last!
        
        // 5.获取AccessToken
        loadAccessToken(code: code)
        
        return false
    }
}

// MARK:- 请求数据
extension OAuthViewController {
    
    fileprivate func loadAccessToken(code: String) {
        
        NetworkTools.shareInstance.loadAccessToken(code: code) { (result, error) in
            
            // 1.错误校验
            if error != nil {
                print("请求token错误:\(error!)")
                return
            }
            
            // 2.检查是否有数据
            guard let accessDict = result else {
                print("没有获取到数据")
                return
            }
            
            // 3.将返回结果装换成模型
            let userAccount = UserAccount.init(dict: accessDict)
            
            // 4.请求用户数据
            self.loadUserInfo(userAccount: userAccount)
        }
    }
    
    /// 请求用户数据
    fileprivate func loadUserInfo(userAccount: UserAccount) {
        
        guard let accessToken = userAccount.access_token else {
            return
        }
        
        guard let uid = userAccount.uid else {
            return
        }
        
        NetworkTools.shareInstance.loadUserInfo(accessToken: accessToken, uid: uid) { (result, error) in
            // 1.错误校验
            if error != nil {
                print("请求用户信息错误:\(error!)")
                return
            }
            
            // 2.拿到用户信息的结果
            guard let userInfoDict = result else {
                return
            }
            
            // 3.将昵称和头像存储到模型中
            userAccount.screen_name = userInfoDict["screen_name"] as? String
            userAccount.avatar_large = userInfoDict["avatar_large"] as? String
            
            // 4.将userAccount对象保存
            // 4.1 获取沙盒路径
            let accountPath = UserAccountViewModel.shareInstance.accountPath
            // 4.2 保存对象
            NSKeyedArchiver.archiveRootObject(userAccount, toFile: accountPath)
            
            // 5.保存模型到视图模型中
            UserAccountViewModel.shareInstance.userAccount = userAccount
            
            // 6.显示欢迎视图
            self.dismiss(animated: false, completion: { 
                UIApplication.shared.keyWindow?.rootViewController = WelcomeViewController()
            })
        }
    }
}

