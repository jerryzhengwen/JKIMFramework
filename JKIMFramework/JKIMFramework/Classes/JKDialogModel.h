//
//  JKDialogModel.h
//  JKIMSDKProject
//
//  Created by Jerry on 2019/3/13.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKENUMObject.h"

typedef NS_ENUM(NSInteger ,JKMsgSource) {
    JK_Visitor = 0,
    JK_Customer = 1,
    JK_Roboter = 2,
    JK_Other,
};



NS_ASSUME_NONNULL_BEGIN

@class JKENUMObject;
@interface JKDialogModel : NSObject

/**
 来源
 */
@property (nonatomic,assign) JKMsgSource whoSend;

/**
 数据类型
 */
@property (nonatomic,assign) JKMessageType messageType;

/**
 内容
 */
@property (nonatomic,copy) NSString *message;
/**
 房间号
 */
@property (nonatomic,copy) NSString *roomId;
/**
 当前时间
 */
@property (nonatomic,copy) NSString *time;
/**
 房间的chatId
 */
@property (nonatomic,copy) NSString *chatId;
/**
 是否是调用http 请求回复
 */
@property (nonatomic,assign) BOOL getHttpResult;

/**
 是否是富文本
 */
@property (nonatomic,assign) BOOL isRichText;
/**
 高度
 */
@property (nonatomic,assign) float imageHeight;

/** 宽度 */
@property (nonatomic,assign) float imageWidth;


@property (nullable, nonatomic, copy) NSString *iconUrl;

@property (nullable, nonatomic, copy) NSString *contentUrl;

@property (nullable, nonatomic, copy) NSString *iconName;

/**
 在线坐席
 */
@property (nonatomic,assign) int customerNumber;

@end

NS_ASSUME_NONNULL_END
