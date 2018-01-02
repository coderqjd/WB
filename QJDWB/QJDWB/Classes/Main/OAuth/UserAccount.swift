//
//  UserAccount.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/11.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {
    
    // MARK:- 属性
    /// 授权accessToken
    var access_token : String?
    /// 过期时间（秒）
    var expires_in : TimeInterval = 0.0 {
        didSet {
            expires_date = NSDate.init(timeIntervalSinceNow: expires_in)
        }
    }
    /// 用户ID
    var uid : String?
    /// 过期时间
    var expires_date : NSDate?
    //** 昵称 */
    var screen_name : String?
    /// 头像URL
    var avatar_large : String?
    
    
    
    // MARK:- 自定义构造函数
    init(dict: [String : Any]) {
        super.init()
            
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {} // 不会因为属性对应不上key而崩溃
    
    // MARK:- 重写description属性
    override var description: String {
        return dictionaryWithValues(forKeys: ["access_token", "expires_date", "uid", "screen_name", "avatar_large"]).description
    }
    
    // MARK:- 归档和解档
    /// 解档
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? NSDate
        uid          = aDecoder.decodeObject(forKey: "uid") as? String
        screen_name  = aDecoder.decodeObject(forKey: "screen_name") as? String
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
    }
    
    /// 归档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(screen_name, forKey: "screen_name")
        aCoder.encode(avatar_large, forKey: "avatar_large")
    }
}
