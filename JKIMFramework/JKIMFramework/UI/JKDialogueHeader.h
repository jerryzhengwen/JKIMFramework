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
#import "JKDialogeContentManager.h"
#import "UIView+JKFloatFrame.h"
#import "JKDialogModel.h"
#import "JKRichTextStatue.h"
#import "JKBundleTool.h"
#import "RegexKitLite.h"
#import "UIViewController+JKImagePicker.h"
#import "YYWebImage.h"
#import "NSString+LocalString.h"

#define iPhoneX ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812)
#define iPhoneXR ([UIScreen mainScreen].bounds.size.width == 414 && [UIScreen mainScreen].bounds.size.height == 896)
#define kStatusBarAndNavigationBarHeight (iPhoneX || iPhoneXR ? 88.f : 64.f)

/** 最大的内容宽度*/
#define MaxContentWidth [UIScreen mainScreen].bounds.size.width - 170

/** 16进制颜色*/
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
/** RGB */
#define RGBColor(r,g,b,a) ([UIColor colorWithRed:r/255.0 green:g/255.00 blue:b/255.0 alpha:a])


#endif /* JKDialogueHeader_h */
