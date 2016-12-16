//
//  UIViewPopupExtension.swift
//  51offer
//
//  Created by Origheart on 16/7/12.
//  Copyright © 2016年 51offer. All rights reserved.
//

import Foundation
import UIKit

enum OFFPopAnimationType: String {
    case Fade = "Fade"
    case Cover = "Cover"
}

fileprivate class PopupAssist {
    var preKeyWindow: UIWindow? = nil
    var newWindow: UIWindow? = nil
}

extension UIView {

    func show(animationType type: OFFPopAnimationType) {
        let screenSize = UIScreen.main.bounds.size
        let newWindow = UIWindow(frame: CGRect(x:0, y:0, width:screenSize.width, height:screenSize.height))
        let viewController = UIViewController()
        viewController.view.frame = UIScreen.main.bounds
        newWindow.rootViewController = viewController

        let popupAssist = PopupAssist()
        popupAssist.preKeyWindow = UIApplication.shared.keyWindow
        popupAssist.newWindow = newWindow

        objc_setAssociatedObject(self, &AssociatedKeys.kMYPopUpAssist, popupAssist, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)

        let kWindow = newWindow
        kWindow.makeKeyAndVisible()

        let overlayView = UIControl(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        overlayView.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        kWindow.addSubview(overlayView)
        kWindow.addSubview(self)
        objc_setAssociatedObject(self, &AssociatedKeys.kMYPopAnimationTypeKey, type.rawValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        objc_setAssociatedObject(self, &AssociatedKeys.kMYPopOverlayViewKey, overlayView, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        switch type {
        case .Fade:
            self.center = CGPoint(x: kWindow.bounds.size.width / 2.0, y: kWindow.bounds.size.height / 2.0)
            self.fadeIn()
        case .Cover:
            var frame = self.frame
            frame.origin.y = overlayView.frame.size.height
            frame.origin.x = (overlayView.frame.size.width-frame.size.width)/2.0
            self.frame = frame;
            self.coverIn()
        }
    }

    func dismiss() {
        let animationType = objc_getAssociatedObject(self, &AssociatedKeys.kMYPopAnimationTypeKey) as! String
        let type = OFFPopAnimationType.init(rawValue: animationType)
        let overlayView = objc_getAssociatedObject(self, &AssociatedKeys.kMYPopOverlayViewKey) as! UIControl
        UIView.animate(withDuration: 0.35, animations: dismissAnimation(type!), completion: { (finished) in
            overlayView.removeFromSuperview()

            self.removeFromSuperview()

            let assist = objc_getAssociatedObject(self, &AssociatedKeys.kMYPopUpAssist) as! PopupAssist
            assist.preKeyWindow?.makeKey()
            assist.preKeyWindow = nil
            assist.newWindow = nil
            objc_setAssociatedObject(self, &AssociatedKeys.kMYPopUpAssist, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        })
    }

    fileprivate struct AssociatedKeys {
        static var kMYPopAnimationTypeKey = "kMYPopAnimationTypeKey"
        static var kMYPopOverlayViewKey = "kMYPopOverlayViewKey"
        static var kMYPopUpAssist = "kMYPopUpAssist"
    }

    fileprivate func fadeIn() {
        self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        self.alpha = 0;
        UIView.animate(withDuration: 0.35, animations: {
            self.alpha = 1.0
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }

    fileprivate func coverIn() {
        UIView.animate(withDuration: 0.35, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: -self.frame.size.height)
        })
    }

    fileprivate func dismissAnimation(_ type:OFFPopAnimationType) -> (Void)->Void {
        var animation: ((Void)->Void)!
        switch type {
        case .Fade:
            animation = {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.alpha = 0.0
            }
        case .Cover:
            animation = {
                self.transform = CGAffineTransform.identity
            }
        }
        return animation
    }
}
