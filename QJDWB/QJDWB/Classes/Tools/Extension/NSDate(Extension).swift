//
//  NSDate(Extension).swift
//  08-15时间处理
//
//  Created by 强进冬 on 2017/8/16.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import Foundation

extension NSDate {

    class func stringWithDateString(from: String) -> String{
    
        // 1.时间格式化对象
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.locale = Locale.init(identifier: "en")
        
        // 2.将字符串时间转换成date类型
        guard let creatDate = fmt.date(from: from) else {
            return ""
        }
        
        // 3.计算当前时间和创建时间的差值
        // 创建当前时间
        let nowDate = NSDate()
        
        let interval = Int(nowDate.timeIntervalSince(creatDate))
        
        // 4.对时间间隔处理
        // 4.1.一分钟以内: 刚刚
        if interval < 60 {
            return "\(interval)秒前"
//            return "刚刚"
        }
        
        // 4.2.一小时以内: xx分钟前
        if interval < 60 * 60 {
            return "\(interval / 60)分钟前"
        }
        
        // 4.3.一天以内: xx小时前
        if interval < 60 * 60 * 24 {
            return "\(interval / (60 * 60))小时前"
        }
        
        // 4.4.昨天: 昨天 08:15
        // 创建日历
        let calendar = Calendar.current
        
        if calendar.isDateInYesterday(creatDate) {
            fmt.dateFormat = "昨天 HH:mm"
            return fmt.string(from: creatDate)
        }
        
        // 4.5.一年之内: 04-20 10:35
        let comps = (calendar as NSCalendar).components(.year, from: creatDate, to: nowDate as Date, options: [])
        if comps.year! < 1 {
            fmt.dateFormat = "MM-dd HH:mm"
            return fmt.string(from: creatDate)
        }
        
        // 4.6.其他: 2013-06-08 16:47
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        return fmt.string(from: creatDate)
    }
}


