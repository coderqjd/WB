//
//  User.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/16.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

class User: NSObject {

    // MARK:- 属性
    /// 头像URL
    var profile_image_url : String?
    /// 昵称
    var screen_name : String?
    /// 认证类型
    var verified_type : Int = -1
    /// 会员等级
    var mbrank : Int = 0
    
    // MARK:- 自定义构造函数
    init(_ dict: [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}
