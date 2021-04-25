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
#import "UIView+JKCommonView.h"
#import "NSDate+Utils.h"
#import "JKMessageOpenUrl.h"
#import "JKLineUpCell.h"
#import "JKLineUpView.h"
#define JKChatContentW  [UIScreen mainScreen].bounds.size.width - 108    //内容宽度
#define iPhoneX ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812)
#define iPhoneXR ([UIScreen mainScreen].bounds.size.width == 414 && [UIScreen mainScreen].bounds.size.height == 896)
#define kStatusBarAndNavigationBarHeight (iPhoneX || iPhoneXR ? 88.f : 64.f)
#define JKBGDefaultColor UIColorFromRGB(0xEFEFEF)

#define JKFontDefaultColor UIColorFromRGB(0x3E3E3E)
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
#define JKContinueLineUp @"http://gzbk.9client.com/continueLineUp"
#define JKGetBussiness @"http://gzbk.9client.com/getBusiness"
#endif /* JKDialogueHeader_h */
