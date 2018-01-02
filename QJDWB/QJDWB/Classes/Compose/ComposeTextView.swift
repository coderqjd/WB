//
//  ComposeTextView.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/23.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTextView: UITextView {

    // MARK:- 懒加载属性
    lazy var placeHolderText : UILabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 初始化操作
        alwaysBounceVertical = true
    }
    
    // MARK:- 重写构造方法
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // 添加子控件
        setupUI()
    }
}

// MARK:- UI设置
extension ComposeTextView {
    
    fileprivate func setupUI() {
        
        addSubview(placeHolderText)
        
        placeHolderText.snp.makeConstraints { (maker) in
            maker.top.equalTo(8)
            maker.left.equalTo(10)
        }
        
        placeHolderText.font = font
        placeHolderText.textColor = UIColor.lightGray
        placeHolderText.text = "分享新鲜事..."
        
        textContainerInset = UIEdgeInsets.init(top: 7, left: 6, bottom: 0, right: 7)
    }
}
