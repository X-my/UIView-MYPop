//
//  UIView+MYPop.m
//  UIViewPop
//
//  Created by Obj on 15/12/9.
//  Copyright © 2015年 Shanghai-Bida. All rights reserved.
//

#import "UIView+MYPop.h"
#import <objc/runtime.h>

typedef void(^AnimationBlock)(void);

#define MYPOP_DEFAULT_DURATION  0.35f

static char kMYPopOverlayViewKey;

static char kMYPopAnimationTypeKey;

static char kMYPopOverlayViewColorKey;


@implementation UIView (MYPop)
#pragma mark - Public Methods

- (void)setOverlayViewColor:(UIColor *)overlayViewColor
{
    objc_setAssociatedObject(self, &kMYPopOverlayViewColorKey, overlayViewColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIColor *)overlayViewColor
{
    return objc_getAssociatedObject(self, &kMYPopOverlayViewColorKey);
}
- (void)showWithAnimationType:(MYPopAnimationType)animationType inView:(UIView*)container
{
    
    UIControl* overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if (container == nil) {
        container = [UIApplication sharedApplication].keyWindow;
    }
    overlayView.backgroundColor = self.overlayViewColor ? :[UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
    
    [overlayView addTarget:self
                    action:@selector(dismiss)
          forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:overlayView];
    [container addSubview:self];
    objc_setAssociatedObject(self, &kMYPopAnimationTypeKey, @(animationType), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, &kMYPopOverlayViewKey, overlayView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    switch (animationType) {
        case MYPopAnimationTypeFade:{
            self.center = CGPointMake(container.bounds.size.width/2.0f,
                                      container.bounds.size.height/2.0f);
            [self fadeInWithOverlayView:overlayView];
        }
            break;
        case MYPopAnimationTypeCover:{
            CGRect frame = self.frame;
            frame.origin.y = overlayView.frame.size.height;
            frame.origin.x = (overlayView.frame.size.width-frame.size.width)/2;
            self.frame = frame;
            [self coverInWithOverlayView:overlayView];
        }
            break;
    }
}
- (void)showWithAnimationType:(MYPopAnimationType)animationType
{
    [self showWithAnimationType:animationType
                         inView:[UIApplication sharedApplication].keyWindow];
    
}
- (void)dismiss {
    [self dismiss:nil];
}
- (void)dismiss:(MYPopCompletion)completion
{
    MYPopAnimationType animationType = [objc_getAssociatedObject(self, &kMYPopAnimationTypeKey)integerValue];
    UIControl* overlayView = objc_getAssociatedObject(self, &kMYPopOverlayViewKey);
    [UIView animateWithDuration:MYPOP_DEFAULT_DURATION
                     animations:[self dismissAnimationWithType:animationType]
                     completion:^(BOOL finished) {
                         if (finished) {
                             [overlayView removeFromSuperview];
                             [self removeFromSuperview];
                             if (completion) {
                                 completion();
                             }
                         }
                     }];
    
    
}
#pragma mark - Fade Animation
- (void)fadeInWithOverlayView:(UIView*)overlayView
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    overlayView.alpha = 0;
    [UIView animateWithDuration:MYPOP_DEFAULT_DURATION animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
        overlayView.alpha = 1;
    }];
    
}
#pragma mark - Cover Animation
- (void)coverInWithOverlayView:(UIView*)overlayView
{
    self.alpha = 0;
    overlayView.alpha = 0;
    [UIView animateWithDuration:MYPOP_DEFAULT_DURATION animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height);
        self.alpha = 1;
        overlayView.alpha = 1;
    }];
}
#pragma mark - Private Methods

- (AnimationBlock)dismissAnimationWithType:(MYPopAnimationType)type
{
    AnimationBlock animation;
    UIControl* overlayView = objc_getAssociatedObject(self, &kMYPopOverlayViewKey);
    switch (type) {
        case MYPopAnimationTypeFade:
        {
            animation = ^{
                self.transform = CGAffineTransformMakeScale(1.3, 1.3);
                self.alpha = 0.0;
                overlayView.alpha = 0.0;
            };
        }
            break;
            
        case MYPopAnimationTypeCover:
        {
            animation = ^{
                self.transform = CGAffineTransformIdentity;
                self.alpha = 0;
                overlayView.alpha = 0.0;
            };
        }
            break;
    }
    return animation;
}

@end
