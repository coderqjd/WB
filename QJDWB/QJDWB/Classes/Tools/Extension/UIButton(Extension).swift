//
//  UIButton(Extension).swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/4.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

extension UIButton {

    // 类方法
    class func creatButton(imageName: String, bgImageName: String) -> UIButton {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: imageName), for: .normal)
        btn.setImage(UIImage.init(named: imageName + "_highlighted"), for: .highlighted)
        btn.setBackgroundImage(UIImage.init(named: bgImageName), for: .normal)
        btn.setBackgroundImage(UIImage.init(named: bgImageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
    
        return btn
    }
    
    // 便利构造函数
    convenience init(imageName: String, bgImageName: String) {
        self.init()
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage.init(named: imageName + "highlighted"), for: .highlighted)
        setBackgroundImage(UIImage.init(named: bgImageName), for: .normal)
        setBackgroundImage(UIImage.init(named: bgImageName + "highlighted"), for: .highlighted)
        sizeToFit()
    }
    
    convenience init(title: String, backgrdColor: UIColor, fontSize: CGFloat) {
        self.init()
        setTitle(title, for: .normal)
        backgroundColor = backgrdColor
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
    
    fileprivate func abc() {}
}
