//
//  TitleButton.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/7.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

class TitleButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setImage(UIImage.init(named: "navigationbar_arrow_down"), for: .normal)
        setImage(UIImage.init(named: "navigationbar_arrow_up"), for: .selected)
        sizeToFit()
        setTitleColor(UIColor.black, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = (titleLabel?.frame.size.width)! + 5
    }
}
