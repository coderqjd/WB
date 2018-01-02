//
//  EmoticonPackage.swift
//  0828-表情键盘
//
//  Created by 强进冬 on 2017/8/28.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

class EmoticonPackage: NSObject {
    
    lazy var emoticons : [Emoticon] = [Emoticon]()

    init(id: String) {
        super.init()
        
        if id == "" {
            addEmptyEmoticon(isRecently: true)
            return
        }
        
        let plist = Bundle.main.path(forResource: id + "/info", ofType: "plist", inDirectory: "Emoticons.bundle")!
        
        let array = NSArray.init(contentsOfFile: plist)! as! [[String : String]]
        
        // 字典数组转模型数组
        var index = 0
        for var dict in array {
            if let png = dict["png"] {
                dict["png"] = id + "/" + png
            }
            
            emoticons.append(Emoticon.init(dict: dict))
            index += 1
            
            // 添加删除按钮
            if index == 20 {
                emoticons.append(Emoticon.init(isRemove: true))
                index = 0
            }
        }
        
        // 添加空白表情
        addEmptyEmoticon(isRecently: false)
    }
    
    fileprivate func addEmptyEmoticon(isRecently: Bool) {
        let count = emoticons.count % 21 // 表示多出几个
        if count == 0 && !isRecently {
            return
        }
        
        for _ in count ..< 20 { // 添加(总数 - 1 - count)个空白表情
            emoticons.append(Emoticon.init(isEmpty: true))
        }
        
        // 添加删除表情
        emoticons.append(Emoticon.init(isRemove: true))
    }
}

