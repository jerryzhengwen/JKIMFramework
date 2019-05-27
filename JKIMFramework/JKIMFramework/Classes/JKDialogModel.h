//
//  JKDialogModel.h
//  JKIMSDKProject
//
//  Created by Jerry on 2019/3/13.
//  Copyright © 2019 于飞. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JKMessage.h"
#import "JKENUMObject.h"


NS_ASSUME_NONNULL_BEGIN
@interface JKDialogModel : JKMessage


/**
 内容
 */
@property (nonatomic,copy) NSString *message;
/**
 图片
 */
@property(nonatomic, strong)UIImage *imageIcon;

/**
 当前时间戳
 */
@property (nonatomic,copy) NSString *time;

/**
 UI展示的时间
 */
//@property (nonatomic,copy) NSString *timeStr;

/**
 是否是调用http 请求回复
 */
@property (nonatomic,assign) BOOL getHttpResult;

//@property (nonatomic, copy) NSString *iconUrl;

@property (nullable, nonatomic, copy) NSString *contentUrl;

//@property (nullable, nonatomic, copy) NSString *iconName;


/**
 在线坐席
 */
@property (nonatomic,assign) int customerNumber;


@property (nonatomic, assign) BOOL showDateLabel;


- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end;


+(JKDialogModel *)changeMsgTypeWithJKModel:(JKMessage *)model;


@end

NS_ASSUME_NONNULL_END
