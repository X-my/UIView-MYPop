//
//  UIView+MYPop.h
//  UIViewPop
//
//  Created by Obj on 15/12/9.
//  Copyright © 2015年 Shanghai-Bida. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MYPopAnimationType) {
    /**
     *  淡入淡出
     */
    MYPopAnimationTypeFade,
    /**
     *  从底部弹出
     */
    MYPopAnimationTypeCover,
};

@interface UIView (MYPop)

- (void)showWithAnimationType:(MYPopAnimationType)animationType;

- (void)dismiss;

@end
