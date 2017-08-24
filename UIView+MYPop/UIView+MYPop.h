//
//  UIView+MYPop.h
//  UIViewPop
//
//  Created by Obj on 15/12/9.
//  Copyright © 2015年 Shanghai-Bida. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, MYPopAnimationType) {
    /**
     *  淡入淡出
     */
    MYPopAnimationTypeFade,
    /**
     *  从底部弹出
     */
    MYPopAnimationTypeCover,
    /**
     *  掉落
     */
    MYPopAnimationTypeDrop,
};
typedef void(^MYPopCompletion)();

@interface UIView (MYPop)

@property (nonatomic, strong) UIColor* overlayViewColor;

- (void)showWithAnimationType:(MYPopAnimationType)animationType inView:(UIView*_Nullable)container;
- (void)showWithAnimationType:(MYPopAnimationType)animationType;

- (void)dismiss;

- (void)dismiss:(nullable MYPopCompletion)completion;

@end
NS_ASSUME_NONNULL_END
