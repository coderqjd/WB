//
//  UserAccountViewModel.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/14.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

class UserAccountViewModel {

    // MARK:- 单例
    static let shareInstance : UserAccountViewModel = UserAccountViewModel()
    
    // MARK:- 属性
    var userAccount : UserAccount?
    
    // MARK:- 计算属性
    var accountPath : String {
        // 1.1获取路径
        let accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return (accountPath as NSString).appendingPathComponent("account.plist")
    }
    
    var isLogin : Bool {
        if userAccount == nil {
            return false
        }
        
        guard let expiresDate = userAccount?.expires_date else {
            return false
        }
        
        // "过期时间"和"当前时间" 比较的结果 == 降序
        return expiresDate.compare(NSDate() as Date) == ComparisonResult.orderedDescending
    }
    
    // MARK:- 构造函数
    init() {
        // 1.2解档获取信息
        userAccount = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
    }
    
    // 尽量使用计算属性替代
//    func isLogin() -> Bool {
//        
//        if account == nil {
//            return false
//        }
//        
//        // 拿到过期时间和当前时间进行比较
//        guard let expiresDate = account?.expires_date else {
//            return false
//        }
//        
//        return (expiresDate.compare(NSDate() as Date) == ComparisonResult.orderedDescending)
//    }
    
}
