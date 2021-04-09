//
//  JKLabHUD.h
//  JKIMSDKProject
//
//  Created by Jerry on 2019/9/21.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKLabHUD : UIView
+ (instancetype)shareHUD;

- (void)showWithMsg:(NSString *)msg;

- (void)showMessageOnTop:(NSString *)messag  View:(UIView*)oView;
@end

NS_ASSUME_NONNULL_END
