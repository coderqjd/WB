//
//  StatusViewModel.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/16.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {

    // MARK:- 属性
    var status : Status?
    
    // MARK:- 对数据处理的属性
    var sourceText : String?            // 处理来源数据处理
    var creatAtText : String?            // 处理创建时间
    var verifiedImage : UIImage?         // 处理认证类型
    var vipImage : UIImage?              // 处理会员图标
    var profileURL : URL?                // 处理头像url
    var picURLs : [URL] = [URL]()        // 处理微博配图
    
    // MARK:- 自定义构造函数
    init(status: Status) {
        self.status = status
        
        // 处理时间
        if let created_at = status.created_at {
            creatAtText = NSDate.stringWithDateString(from: created_at)
        }
        
        // 处理微博来源
        if let source = status.source, source != ""  {
            
            // <a href=\"http://app.weibo.com/t/feed/4J5QJ9\" rel=\"nofollow\">小米手机5</a>
            let startIndex = (source as NSString).range(of: ">").location + 1
            let length = (source as NSString).range(of: "</").location - startIndex
            
            sourceText = "来自" + (source as NSString).substring(with: NSRange.init(location: startIndex, length: length))
        }
        
        // 处理认证类型
        let verified_type = status.user?.verified_type ?? -1
        switch verified_type {
        case 0:
            verifiedImage = UIImage.init(named: "avatar_vip")
        case 2, 3, 5:
            verifiedImage = UIImage.init(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage.init(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        
        // 处理会员等级
        let mbrank = status.user?.mbrank ?? 0
        if mbrank > 0 && mbrank < 7 {
            vipImage = UIImage.init(named: "common_icon_membership_level\(mbrank)")
        }
        
        // 处理头像URL
        let urlStr = status.user?.profile_image_url ?? ""
        profileURL = URL.init(string: urlStr)
        
        // 处理微博配图
        let picUrlDicts = status.pic_urls?.count != 0 ? status.pic_urls : status.retweeted_status?.pic_urls
        if let picUrlDicts = picUrlDicts {
            for dict in picUrlDicts {
                
                guard let picUrlString = dict["thumbnail_pic"] else {
                    continue
                }
                picURLs.append(URL.init(string: picUrlString)!)
            }
        }
        
    }
}
