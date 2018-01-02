//
//  PhotoBrowserAnimator.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/9/5.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

// MARK:- 弹出动画协议
protocol PresentedAnimatorDelegate : NSObjectProtocol {
    func presentedAnimator(_ animator: PhotoBrowserAnimator, imageViewStartRectWith indexPath: IndexPath) -> CGRect
    func presentedAnimator(_ animator: PhotoBrowserAnimator, imageViewEndRectWith indexPath: IndexPath) -> CGRect
    func presentedAnimator(_ animator: PhotoBrowserAnimator, imageViewWith indexPath: IndexPath) -> UIImageView
}

protocol DismissedAnimatorDelegate : NSObjectProtocol {
    func indexPathForDismiss(in animator : PhotoBrowserAnimator) -> IndexPath
    func imageViewForDismiss(in animator : PhotoBrowserAnimator) -> UIImageView
}


class PhotoBrowserAnimator: NSObject {
    
    // MARK:- 属性
    var isPrensented : Bool = false
    var indexPath : IndexPath?
    weak var presentDelegate : PresentedAnimatorDelegate?
    weak var dismissDelegate : DismissedAnimatorDelegate?
}


// MARK:- 设置转场动画代理
extension PhotoBrowserAnimator : UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPrensented = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPrensented = false
        return self
    }
}


// MARK:- 转场动画代理方法
extension PhotoBrowserAnimator : UIViewControllerAnimatedTransitioning {
    
    // 动画时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    // 判断是弹出还是消失动画
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPrensented {
            animateTransitionForPresented(using: transitionContext)
        } else {
            animateTransitionForDismissed(using: transitionContext)
        }
    }
    
    // 自定义弹出动画
    fileprivate func animateTransitionForPresented(using transitionContext: UIViewControllerContextTransitioning) {
        guard let presentDelegate = presentDelegate, let indexPath = indexPath else {
            return
        }
        
        // 1.获取弹出的 view
        guard let presentView = transitionContext.view(forKey: .to) else {
            return
        }
        
        // 2.添加到 containView 上
        transitionContext.containerView.addSubview(presentView)
        
        // 获取imageView
        let startFrame = presentDelegate.presentedAnimator(self, imageViewStartRectWith: indexPath)
        let endFrame = presentDelegate.presentedAnimator(self, imageViewEndRectWith: indexPath)
        let imageView = presentDelegate.presentedAnimator(self, imageViewWith: indexPath)
        transitionContext.containerView.addSubview(imageView)
        
        // 3.执行动画
        imageView.frame = startFrame
        presentView.alpha = 0.0
        imageView.alpha = 0.3
        transitionContext.containerView.backgroundColor = UIColor.black
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView.frame = endFrame
            imageView.alpha = 1.0
        
        }) { (_) in
            presentView.alpha = 1.0
            imageView.removeFromSuperview()
            transitionContext.containerView.backgroundColor = UIColor.clear
            transitionContext.completeTransition(true)
        }
    }
    
    // 自定义消失动画
    fileprivate func animateTransitionForDismissed(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let dismissDelegate = dismissDelegate, let presentDelegate = presentDelegate else {
            return
        }
        
        // 获取消失动画的View
        guard let dismissView = transitionContext.view(forKey: .from) else {
            return
        }
        dismissView.removeFromSuperview()

        let indexPath = dismissDelegate.indexPathForDismiss(in: self)
        let imageView = dismissDelegate.imageViewForDismiss(in: self)
        transitionContext.containerView.addSubview(imageView)
        // 执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView.frame = presentDelegate.presentedAnimator(self, imageViewStartRectWith: indexPath)
        }) { (_) in
            imageView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
