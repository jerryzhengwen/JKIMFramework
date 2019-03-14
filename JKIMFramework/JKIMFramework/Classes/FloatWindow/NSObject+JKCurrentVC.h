//
//  NSObject+JKCurrentVC.h
//  JKIMSDKProject
//
//  Created by zzx on 2019/3/8.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (JKCurrentVC)

+ (UIViewController *)currentViewController;

+ (UINavigationController *)currentNavigationController;

+ (UITabBarController *)currentTabBarController;

@end

NS_ASSUME_NONNULL_END
