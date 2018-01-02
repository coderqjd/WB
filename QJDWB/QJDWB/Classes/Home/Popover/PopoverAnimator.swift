//
//  PopoverAnimator.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/8.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject {
    
    // MARK:- 属性
    var presentViewFrame : CGRect = CGRect.zero

    var isPresented : Bool = false
    
    var callBack : ((_ isPresented : Bool) -> ())?
    
    // MARK:- 自定义构造函数
    init(callBack : @escaping (_ isPresented : Bool) -> ()) {
        self.callBack = callBack
    }
}

// MARK:- 自定义转场代理的方法
extension PopoverAnimator : UIViewControllerTransitioningDelegate {
    // 自定义弹出view的frame
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let presentation = QJDPresentationController.init(presentedViewController: presented, presenting: presenting)
        presentation.presentedViewFrame = presentViewFrame
        return presentation
    }
    
    // 自定义弹出的动画（相当于设置代理为 self）
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        callBack!(isPresented)
        return self
    }
    
    // 自定义消失的动画（相当于设置代理为 self）
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        callBack!(isPresented)
        return self
    }
}

// MARK:- 弹出和消失的动画代理方法
extension PopoverAnimator : UIViewControllerAnimatedTransitioning {
    
    // 动画执行的时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    // 动画
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresented(using: transitionContext) : animationForDismissed(using: transitionContext)
    }
}

// MARK:- 自定义弹出和消失动画的方法
extension PopoverAnimator {
    
    fileprivate func animationForPresented(using transitionContext: UIViewControllerContextTransitioning) {
        // 1.获取弹出的presentedView
        let presentedView = transitionContext.view(forKey: .to)!
        
        // 2.将弹出presentedView添加到containerView上
        transitionContext.containerView.addSubview(presentedView)
        
        // 3.执行动画
        presentedView.transform = CGAffineTransform.init(scaleX: 1.0, y: 0.0)
        presentedView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            presentedView.transform = CGAffineTransform.identity
            
        }) { (_) in
            // 必须告诉转场上下文已经完成动画
            transitionContext.completeTransition(true)
        }
    }
    
    fileprivate func animationForDismissed(using transitionContext: UIViewControllerContextTransitioning) {
        // 1.获取消失的dismissedView
        let dismissedView = transitionContext.view(forKey: .from)
        
        // 2.执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            dismissedView?.transform = CGAffineTransform.init(scaleX: 1.0, y: CGFloat(1.0 / MAXFLOAT))
            
        }) { (_) in
            dismissedView?.removeFromSuperview()
            
            transitionContext.completeTransition(true)
        }
    }
}
