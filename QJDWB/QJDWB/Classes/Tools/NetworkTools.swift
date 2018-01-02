//
//  NetworkTools.swift
//  AFNetworking的封装
//
//  Created by 强进冬 on 2017/8/9.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit
import AFNetworking

// 定义枚举类型
enum RequestType : String {
    case get = "GET"
    case post = "POST"
}

class NetworkTools: AFHTTPSessionManager {
    
    fileprivate var parameters : NSMutableDictionary = NSMutableDictionary()

    // 单例
    static let shareInstance : NetworkTools = {
        let tools = NetworkTools()
        
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return tools
    }()
    
}

// MARK:- 封装请求方法
extension NetworkTools {
    
    func request(methodType: RequestType, urlString: String, parameters: [String : Any], finished: @escaping (_ result: AnyObject?, _ error: NSError?) -> ()) {
        
        self.parameters = parameters as! NSMutableDictionary
        
        let successCallBack = { (task: URLSessionDataTask, result: Any?) in
            if self.parameters != (parameters as! NSMutableDictionary) {
                return
            }
            finished(result as AnyObject, nil)
        }
        
        let failureCallBack = { (task: URLSessionDataTask?, error: Error) in
            if self.parameters != (parameters as! NSMutableDictionary) {
                return
            }
            finished(nil, error as NSError)
        }
        
        if methodType == .get {
            get(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
            
        } else if methodType == .post {
            post(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }
    }
}

// MARK:- 请求AccessToken
extension NetworkTools {
    
    func loadAccessToken(code: String, finished: @escaping (_ result: [String : Any]?, _ error: NSError?) -> ()) {
        
        // 1.获取请求的URLString
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        // 2.请求的参数
        let parameters = [    "client_id" : app_key,
                          "client_secret" : app_secret,
                             "grant_type" : "authorization_code",
                                   "code" : code,
                           "redirect_uri" : redirect_uri]
        
        // 3.发送网络请求
        request(methodType: .post, urlString: urlString, parameters: parameters) { (result, error) in
            
            finished(result as? Dictionary<String, Any>, error)
        }
    }
}

// MARK:- 请求用户数据
extension NetworkTools {
    
    func loadUserInfo(accessToken: String, uid: String, finished: @escaping (_ result: [String : Any]?, _ error: NSError?) -> ()) {
        
        // 1.获取请求的urlstring
        let urlstring = "https://api.weibo.com/2/users/show.json"
        
        // 2.请求的参数
        let parameters = ["access_token" : accessToken,
                                   "uid" : uid]
        
        // 3.发送网络请求
        request(methodType: .get, urlString: urlstring, parameters: parameters) { (result, error) in
            finished(result as? [String : Any], error)
        }
        
    }
}

// MARK:- 请求首页数据
extension NetworkTools {

    func loadStatuses(since_id: Int, max_id: Int, finished: @escaping (_ result: [[String : Any]]?, _ error: NSError?) -> ()) {
        
        // 1.请求的url
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        // 2.请求参数
        let parameters = ["access_token" : (UserAccountViewModel.shareInstance.userAccount?.access_token)!,
                              "since_id" : "\(since_id)",
                                "max_id" : "\(max_id)"]
        
        // 3.发送请求
        request(methodType: .get, urlString: urlString, parameters: parameters) { (result, error) in
            QJDLog(result)
            guard let resultDict = result as? [String : Any] else {
                finished(nil, error)
                return
            }
            
            finished(resultDict["statuses"] as? [[String : Any]], error)
        }
    }
}

// MARK:- 发送文字微博
extension NetworkTools {

    func sendStatus(text: String, isSuccessed: @escaping (_ isSuccessed: Bool, _ error: NSError?) -> ()) {
        // 1.请求的url
        let urlString = "https://api.weibo.com/2/statuses/share.json"
        
        // 2.请求的参数
        let parameters = ["access_token" : (UserAccountViewModel.shareInstance.userAccount?.access_token)!,
                                "status" : text + "http://qjd.ressh.cn"]
        
        // 3.发送请求
        request(methodType: .post, urlString: urlString, parameters: parameters) { (result, error) in
            if result != nil {
                isSuccessed(true, nil)
            }else {
                isSuccessed(false, error)
            }
        }
    }
}



