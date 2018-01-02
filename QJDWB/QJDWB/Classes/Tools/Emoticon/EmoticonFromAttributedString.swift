//
//  EmoticonFromAttributedString.swift
//  0901-表情显示
//
//  Created by 强进冬 on 2017/9/1.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

class EmoticonFromAttributedString: NSObject {
    
    lazy var manager : EmoticonManager = EmoticonManager()
    
    // 单例
    static let shareInstance : EmoticonFromAttributedString = EmoticonFromAttributedString()

    func showAttributedString(text: String?, font: UIFont) -> NSAttributedString? {
        guard let text = text else {
            return nil
        }
        
        let attrString = NSMutableAttributedString.init(string: text)
        
        // 1.创建规则
        let pattern = "\\[.*?\\]"  // .: 任何字符, *: 任何数量, ?: 一旦符合条件就截取
        
        // 2.创建正则表达式对象
        guard let regex = try? NSRegularExpression.init(pattern: pattern, options: []) else {
            return attrString
        }
        
        // 3.匹配
        let results = regex.matches(in: text, options: [], range: NSRange.init(location: 0, length: text.characters.count))
        
        // 4.获取结果
        // 获取要显示的属性字符串
        for result in results.reversed() {
            let chs = (text as NSString).substring(with: result.range)
            
            guard let pngPath = foundPngPathWith(chs) else {
                return attrString
            }
            
            // 创建显示图片的属性字符串
            let image = UIImage.init(contentsOfFile: pngPath)
            let attachment = NSTextAttachment.init()
            attachment.image = image
            attachment.bounds = CGRect.init(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let attrImgStr = NSAttributedString.init(attachment: attachment)
            
            // 替换属性字符串
            attrString.replaceCharacters(in: result.range, with: attrImgStr)
        }
        
        return attrString
    }
    
    fileprivate func foundPngPathWith(_ chs: String) -> String? {
        
        for package in manager.packages {
            for emoticon in package.emoticons {
                if emoticon.chs == chs {
                    return emoticon.pngPath
                }
            }
        }
        
        return nil
    }
}
