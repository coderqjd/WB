//
//  VisitorView.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/4.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit
import SDWebImage

class VisitorView: UIView {

    class func visitView() -> VisitorView {
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)?.last as! VisitorView
    }
    
    // MARK:- 控件属性
    @IBOutlet weak var rotationView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var registBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    func setupVisitorViewInfo(iconName: String, title: String) {
        iconView.image = UIImage.init(named: iconName)
        tipLabel.text = title
        rotationView.isHidden = true
    }
    
    // MARK:- 添加旋转动画
    func addRotationAnimation() {
        // 创建动画
        let rotationAnim = CABasicAnimation.init(keyPath: "transform.rotation.z")
        
        // 设置属性
        rotationAnim.fromValue = 0
        rotationAnim.toValue = Double.pi * 2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 6
        rotationAnim.isRemovedOnCompletion = false // 不移除动画
        
        // 添加到layer
        rotationView.layer.add(rotationAnim, forKey: nil)
    }
}
