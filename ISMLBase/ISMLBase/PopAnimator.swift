//
//  PopAnimator.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 4/20/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit

public class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    public let duration    = 1.0
    public var presenting  = true
    public var originFrame = CGRect.zero
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        let toView =
            transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        let herbView = presenting ? toView : transitionContext.view(forKey: UITransitionContextViewKey.from)!
        
        
        let initialFrame = presenting ? originFrame : herbView.frame
        let finalFrame = presenting ? herbView.frame : originFrame
        
        let xScaleFactor = presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if presenting {
            herbView.transform = scaleTransform
            herbView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
            herbView.clipsToBounds = true
        }
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(herbView)
        
        UIView.animate(withDuration: duration, delay:0.0,
                                   usingSpringWithDamping: 0.4,
                                   initialSpringVelocity: 0.0,
                                   options: [],
                                   animations: {
                                    herbView.transform = self.presenting ?
                                        .identity : scaleTransform
                                    
                                    herbView.center = CGPoint(x: finalFrame.midX,
                                                              y: finalFrame.midY)
                                    
        }, completion:{_ in
            transitionContext.completeTransition(true)
        })
    }
}
