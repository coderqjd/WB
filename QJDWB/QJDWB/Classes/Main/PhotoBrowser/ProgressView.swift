//
//  ProgressView.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/9/4.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    
    var progress : CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let center = CGPoint.init(x: rect.width * 0.5, y: rect.height * 0.5)
        let radius = rect.width * 0.5 - 3
        let startAngle = -CGFloat.pi * 0.5
        let endAngle = startAngle + CGFloat.pi * 2 * progress
        
        // 创建贝塞尔曲线
        let path = UIBezierPath.init(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        path.addLine(to: center)
        
        UIColor.init(white: 1.0, alpha: 0.4).setFill()
        
        // 开始绘制
        path.fill()
    }

}
