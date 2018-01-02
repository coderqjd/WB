//
//  UITextView(Extension).swift
//  0828-表情键盘
//
//  Created by 强进冬 on 2017/8/31.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

extension UITextView {

    /// 插入表情
    func insertEmoticon(_ emoticon: Emoticon) {
        // 空表情
        if emoticon.isEmpty {
            return
        }
        
        // 删除表情
        if emoticon.isRemove {
            deleteBackward()
        }
        
        // emoji表情
        if let emojiCode = emoticon.emojiCode {
            // 光标的位置
            let range = selectedTextRange!
            replace(range, withText: emojiCode)
        }
        
        // 普通表情(图文混排)
        if let pngPath = emoticon.pngPath {
            // 1.根据 NSTextAttachment 创建图片属性字符串
            let attachment = EmoticonAttachment()
            attachment.chs = emoticon.chs
            attachment.image = UIImage.init(contentsOfFile: pngPath)
            let font = self.font!
            attachment.bounds = CGRect.init(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let imageAttrStr = NSAttributedString.init(attachment: attachment)
            
            // 2.创建可变的属性字符串
            let mutaAttrStr = NSMutableAttributedString.init(attributedString: attributedText)
            
            let range = selectedRange
            mutaAttrStr.replaceCharacters(in: range, with: imageAttrStr)
            
            // 3.设置属性字符串
            attributedText = mutaAttrStr
            
            // 4.重置文字大小和光标位置
            self.font = font
            selectedRange = NSRange.init(location: range.location + 1, length: 0)
        }
    }
    
    /// 获取表情字符串
    func getEmoticonString() -> String {
        let attrStr = NSMutableAttributedString.init(attributedString: attributedText)
        
        let range = NSRange.init(location: 0, length: attrStr.length)
        attrStr.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            
            if let attachment =  dict["NSAttachment"] as? EmoticonAttachment {
                attrStr.replaceCharacters(in: range, with: attachment.chs!)
            }
        }
        
        return attrStr.string
    }
    
}
