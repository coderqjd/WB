//
//  Status.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/15.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

class Status: NSObject {

    // MARK:- 属性
    /// 创建时间
    var created_at : String?
    /// 微博来源
    var source : String?
    /// 微博正文
    var text : String?
    /// 微博id
    var mid : Int = 0
    /// 用户
    var user : User?
    /// 内容图片
    var pic_urls : [[String : String]]?
    /// 转发微博
    var retweeted_status : Status?
    
    // MARK:- 自定义构造函数
    init(_ dict: [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
        
        // 将用户字典转换成用户模型
        if let userDict = dict["user"] as? [String : Any] {
            user = User.init(userDict)
        }
        
        // 将转发微博字典转换成模型
        if let retweetedDict = dict["retweeted_status"] as? [String : Any] {
            retweeted_status = Status.init(retweetedDict)
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
