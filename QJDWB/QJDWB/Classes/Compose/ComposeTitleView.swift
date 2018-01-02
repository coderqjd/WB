//
//  ComposeTitleView.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/23.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTitleView: UIView {

    // MARK:- 懒加载
    fileprivate lazy var title : UILabel = UILabel()
    fileprivate lazy var screenName : UILabel = UILabel()
    
    // MARK:- 重写构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK:- UI界面设置
extension ComposeTitleView {

    // 添加子控件
    fileprivate func setupUI() {
        addSubview(title)
        addSubview(screenName)
        
        // 设置约束
        title.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview()
        }
        screenName.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(title.snp.centerX)
            maker.top.equalTo(title.snp.bottom).offset(3)
        }
        
        // 设置控件属性
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .center
        title.text = "发微博"
        screenName.font = UIFont.systemFont(ofSize: 14)
        screenName.textColor = UIColor.lightGray
        screenName.textAlignment = .center
        screenName.text = UserAccountViewModel.shareInstance.userAccount?.screen_name
    }
}
