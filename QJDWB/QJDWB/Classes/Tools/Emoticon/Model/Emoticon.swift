//
//  Emoticon.swift
//  0828-表情键盘
//
//  Created by 强进冬 on 2017/8/28.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

class Emoticon: NSObject {

    // MARK:- 属性
    var chs : String?    // 普通表情对应的文字
    var png : String? {  // 普通表情对应的图片
        didSet {
            guard let png = png else {
                return
            }
            pngPath = Bundle.main.bundlePath + "/Emoticons.bundle/" + png
        }
    }
    var code : String? { // emoji表情
        didSet {
            guard let code = code else {
                return
            }
            
            // 1.创建扫描器
            let scanner = Scanner.init(string: code)
            
            // 2.扫描出code值
            var value : UInt32 = 0
            scanner.scanHexInt32(&value)
            
            // 3.将改值转成字符
            let c = Character.init(UnicodeScalar.init(value)!)
            
            // 4.将字符转成字符串
            emojiCode = String.init(c)
        }
    }
    // MARK:- 数据处理属性
    var pngPath : String?
    var emojiCode : String?
    var isRemove : Bool = false
    var isEmpty : Bool = false
    
    // MARK:- 自定义构造函数
    init(dict: [String : String]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
    
    init(isRemove: Bool) {
        self.isRemove = isRemove
    }
    
    init(isEmpty: Bool) {
        self.isEmpty = isEmpty
    }
    
    override var description: String {
        return dictionaryWithValues(forKeys: ["chs", "emojiCode", "pngPath"]).description
    }
    
}
