//
//  HWPlayerPresentationController.swift
//  Player
//
//  Created by 趙傳龍 on 2016/10/13.
//  Copyright © 2016年 Huan. All rights reserved.
//

import UIKit

class HWPlayerPresentationController: UIPresentationController {

    //模糊视图
    var bgView = UIView()
    
    
    
    //在呈现过渡即将开始的时候被调用的
    override func presentationTransitionWillBegin() {
        
        //背景模糊视图添加点击取消手势
        bgView = UIView.init(frame: UIScreen.main.bounds)
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(dismissalTransition));
        bgView.addGestureRecognizer(tapGestureRecognizer)
        
        //给背景视图添加毛玻璃效果
        let visualEffectView = UIVisualEffectView.init(effect: UIBlurEffect.init(style: UIBlurEffectStyle.dark))
        visualEffectView.frame = (self.containerView?.bounds)!
        
        bgView.insertSubview(visualEffectView, at: 0)
        self.containerView?.addSubview(bgView)
        
        //presenting view 缩小到原来的0.92
        let coordinator = self.presentingViewController.transitionCoordinator
        coordinator?.animate(alongsideTransition: { (coordinator) in
            self.bgView.alpha = 0.7
            self.presentingViewController.view.transform.scaledBy(x: 0.92, y: 0.92)
            }) { (coordinator) in}
        
    }
    
    
    //呈现结束的时候恢复视图
    override func dismissalTransitionWillBegin() {
        let coordinator = self.presentingViewController.transitionCoordinator
        coordinator?.animate(alongsideTransition: { (coordinator) in
            self.bgView.alpha = 0
            self.presentingViewController.view.transform.inverted()
            }, completion: nil)
    }
    
    //移除视图
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            bgView.removeFromSuperview()
        }
    }
    
//    override var frameOfPresentedViewInContainerView: CGRect = CGRect(x: 0, y:0, width:100, height:100)
    
    //退出当前controller
    @objc private func dismissalTransition() {
        self.presentingViewController.dismiss(animated: true, completion: nil)
    }
}
