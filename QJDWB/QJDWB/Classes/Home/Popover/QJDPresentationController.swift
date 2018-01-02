//
//  QJDPresentationController.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/8.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

class QJDPresentationController: UIPresentationController {
    
    var presentedViewFrame : CGRect = CGRect.zero
    
    // MARK:- 懒加载属性
    lazy var coverView = UIView()
    
    // MARK:- 系统回调方法
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        // 设置弹出presentedView的frame
        presentedView?.frame = presentedViewFrame
        
        // 添加蒙版
        setupCoverView()
    }
}

// MARK:- UI界面
extension QJDPresentationController {
    
    fileprivate func setupCoverView() {
        // 设置蒙版的frame
        coverView.frame = containerView!.bounds
        
        // 蒙版的颜色
        coverView.backgroundColor = UIColor.init(white: 0.8, alpha: 0.5)
        
        // 给蒙版添加手势
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(coverViewClick))
        coverView.addGestureRecognizer(tapGes)
        
        // 添加蒙版
        containerView?.insertSubview(coverView, at: 0)
    }
}

// MARK:- 事件监听
extension QJDPresentationController {
    @objc fileprivate func coverViewClick() {
        presentedViewController.dismiss(animated: true, completion: nil)
        QJDLog(presentedViewController)
    }
}
