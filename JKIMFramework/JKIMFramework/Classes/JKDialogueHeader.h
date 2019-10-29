//
//  JKDialogueHeader.h
//  JKIMSDKProject
//
//  Created by zzx on 2019/4/3.
//  Copyright © 2019 于飞. All rights reserved.
//

#ifndef JKDialogueHeader_h
#define JKDialogueHeader_h

#import "JKPluginView.h"
#import "JKPluginModel.h"
#import "JKFloatBallManager.h"
#import "JKConnectCenter.h"
#import "JYFaceView.h"
#import "JKDialogueSetting.h"
#import "UIView+JKFloatFrame.h"
#import "JKDialogModel.h"
#import "JKRichTextStatue.h"
#import "JKBundleTool.h"
#import "UIViewController+JKImagePicker.h"


#define iPhoneX ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812)
#define iPhoneXR ([UIScreen mainScreen].bounds.size.width == 414 && [UIScreen mainScreen].bounds.size.height == 896)
#define kStatusBarAndNavigationBarHeight (iPhoneX || iPhoneXR ? 88.f : 64.f)
#define JKBGDefaultColor UIColorFromRGB(0xEFEFEF)
/** 最大的内容宽度*/
#define MaxContentWidth [UIScreen mainScreen].bounds.size.width - 103

/** 16进制颜色*/
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
/** RGB */
#define RGBColor(r,g,b,a) ([UIColor colorWithRed:r/255.0 green:g/255.00 blue:b/255.0 alpha:a])

#define JKDefaultColor UIColorFromRGB(0x333333)
#define JKWeakSelf __weak typeof (self)weakSelf = self

//时间字体
#define JKChatTimeFont [[UIDevice currentDevice].systemVersion doubleValue] <9.0?    [UIFont systemFontOfSize:12]:[UIFont fontWithName:@"PingFangSC-Regular" size:12]
//内容字体
#define JKChatContentFont [[UIDevice currentDevice].systemVersion doubleValue] <9.0?    [UIFont systemFontOfSize:15]: [UIFont fontWithName:@"PingFangSC-Regular" size:15]

#endif /* JKDialogueHeader_h */
