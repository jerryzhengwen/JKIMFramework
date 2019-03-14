//
//  NSObject+JKCurrentVC.m
//  JKIMSDKProject
//
//  Created by zzx on 2019/3/8.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "NSObject+JKCurrentVC.h"

@implementation NSObject (JKCurrentVC)


+ (UIViewController *)currentViewController
{
    UIViewController *result = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        UIViewController *vc = (UIViewController *)nextResponder;
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController *) vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController *) vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }
        while (vc.childViewControllers.count) {
            vc = [vc.childViewControllers lastObject];
        }
        result = vc;
    }
    else {
        result = window.rootViewController;
    }
    return result;
}

+ (UINavigationController *)currentNavigationController
{
    return [self currentViewController].navigationController;
}

+ (UITabBarController *)currentTabBarController
{
    return [self currentViewController].tabBarController;
}

@end
