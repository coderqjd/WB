//
//  EmoticonManager.swift
//  0828-表情键盘
//
//  Created by 强进冬 on 2017/8/28.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

class EmoticonManager {

    var packages : [EmoticonPackage] = [EmoticonPackage]()
    
    init() {
        packages.append(EmoticonPackage.init(id: ""))
        packages.append(EmoticonPackage.init(id: "com.sina.default"))
        packages.append(EmoticonPackage.init(id: "com.apple.emoji"))
        packages.append(EmoticonPackage.init(id: "com.sina.lxh"))
    }
    
}
