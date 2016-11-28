//
//  HWPlayerAnimation.swift
//  Player
//
//  Created by 趙傳龍 on 2016/10/17.
//  Copyright © 2016年 Huan. All rights reserved.
//

import UIKit

class HWPlayerAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresenting = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting{
            self.animatePresentationWithTransitionContext(transitionContext)
        }else{
            self.animateDismissalWithTransitionContext(transitionContext)
        }
    }
    
    
    //MARK: - Animation
    
    //切入动画
    func animatePresentationWithTransitionContext(_ transitionContext:UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        
        let screenBounds = UIScreen.main.bounds
        let finalFrame = transitionContext.finalFrame(for: toViewController!)
        toViewController?.view.frame = finalFrame.offsetBy(dx: 0, dy: screenBounds.size.height)
        
        let containerView = transitionContext.containerView
        containerView.addSubview((toViewController?.view)!)
        
        UIView.animate(withDuration: 0.5, animations: { 
            toViewController?.view.frame = finalFrame.offsetBy(dx: 0, dy: 40);
            }) { (Bool) in
                transitionContext.completeTransition(true)
        }
        
        
    }
    
    //切出动画
    func animateDismissalWithTransitionContext(_ transitionContext:UIViewControllerContextTransitioning){
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        
        UIView.animate(withDuration: 0.5, animations: { 
            fromViewController?.view.frame = CGRect(x:0, y:UIScreen.main.bounds.size.height, width:(fromViewController?.view.frame.size.width)!, height:(fromViewController?.view.frame.size.height)!)
            }) { (Bool) in
                transitionContext.completeTransition(true)
        }
    }
    
}
