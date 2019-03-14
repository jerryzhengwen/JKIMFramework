//
//  JKFloatBallManager.h
//  JKIMSDKProject
//
//  Created by zzx on 2019/3/8.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

extern NSString *const kPopInteractiveKey;
extern NSString *const kAnimatorKey;
//该pop为右滑手势
extern NSString *const kPopWithPanGes;

NS_ASSUME_NONNULL_BEGIN

@interface JKFloatBallManager : NSObject<UIGestureRecognizerDelegate>

+ (instancetype)shared;
/** 添加需要监控添加悬浮球的控制器类名 */
- (void)addFloatMonitorVCClasses:(NSArray<NSString *> *)VCClasses;

/**
 如果自身设置了interactivePopGestureRecognizer.delegate的代理，并且系统自身的右滑手势无法识别。
 请添加类似如下代码
 - (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
 {
 if (self.viewControllers.count <= 1) {
 return NO;
 }
 return YES;
 }
 */

/**
 如果自身设置了UINavigationControllerDelegate的代理
 需要添加类似如下代码
 - (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
 animationControllerForOperation:(UINavigationControllerOperation)operation
 fromViewController:(UIViewController *)fromVC
 toViewController:(UIViewController *)toVC
 {
 return [[FloatBallManager shared] floatBallAnimationWithOperation:operation fromViewController:fromVC toViewController:toVC];
 }
 */
- (id <UIViewControllerAnimatedTransitioning>)floatBallAnimationWithOperation:(UINavigationControllerOperation)operation
                                                           fromViewController:(UIViewController *)fromVC
                                                             toViewController:(UIViewController *)toVC;

/**
 如果自身设置了UINavigationControllerDelegate的代理
 需要添加类似如下代码
 - (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
 interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
 {
 return [[FloatBallManager shared] floatInteractionControllerForAnimationController:animationController];
 }
 */
- (id <UIViewControllerInteractiveTransitioning>)floatInteractionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController;

/**
 如果自身设置了UINavigationControllerDelegate的代理
 需要添加类似如下代码
 - (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
 {
 [[FloatBallManager shared] didShowViewController:viewController navigationController:navigationController];
 }
 */
- (void)didShowViewController:(UIViewController *)viewController navigationController:(UINavigationController *)navigationController;

- (void)hiddenFloatBall;
- (void)showFloatBallWithViewController:(UIViewController *)fromVC;

@end

NS_ASSUME_NONNULL_END
