//
//  JKDialogueSetting.h
//  JKIMSDKProject
//
//  Created by zzx on 2019/3/12.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKDialogueSetting : NSObject

///单例
+ (instancetype)sharedSetting;

//-----------------        对话界面      -----------------------
///对话列表的头像 坐席头像
@property(nonatomic, strong)UIImage  *customerImage;
///访客头像
@property(nonatomic, strong)UIImage  *visitorImage;
///对话列表是否需要设置圆的头像
@property (nonatomic,assign)BOOL     DialogueListHeadImageNeedCircle;


//-----------------   NavigationBarSetting -----------------------
///NavigationBar的颜色
@property(nonatomic, strong)UIColor  *navigationBarColor;
//NavigationBar的标题Font
@property(nonatomic, strong)UIFont   *navigationBarTitleFont;
//NavigationBar的标题颜色
@property(nonatomic, strong)UIColor  *navigationBarTitleColor;
//NavigationBar的标题名字
@property(nonatomic, copy)NSString   *navigationBarTitle;

@end

NS_ASSUME_NONNULL_END
