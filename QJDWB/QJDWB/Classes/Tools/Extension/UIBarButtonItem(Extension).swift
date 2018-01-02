//
//  UIBarButtonItem(Extension).swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/7.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
   
    convenience init(imageName: String) {
        self.init()
        
        let btn = UIButton()
        btn.setImage(UIImage.init(named: imageName), for: .normal)
        btn.setImage(UIImage.init(named: imageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        
        customView = btn
    }
    
    convenience init(title: String, target: Any?, action: Selector) {
        
        let btn = UIButton()
        btn.setTitle(title, for: .normal)
        btn.sizeToFit()
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.setTitleColor(UIColor.orange, for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .highlighted)
        btn.backgroundColor = UIColor.red
        
        self.init(customView: btn)
    }
}
