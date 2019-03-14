//
//  JKMessage.h
//  JKIMSDK
//
//  Created by Jerry on 2019/3/8.
//  Copyright © 2019 zzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKENUMObject.h"
NS_ASSUME_NONNULL_BEGIN

@interface JKMessage : NSObject
/**
 内容
 */
@property(nonatomic,copy) NSString *content;
/**
 房间Id
 */
@property(nonatomic,copy) NSString *roomId;
/**
 chatId;
 */
@property(nonatomic,copy) NSString *chatId;
/**
 发送至
 */
@property(nonatomic,copy) NSString *to;
/**
 谁发送来的
 */
@property(nonatomic,copy) NSString *form;
/**
 消息类型
 */
@property(nonatomic,assign) JKMessageType messageType;
/**
 语音地址
 */
@property(nonatomic,copy) NSString *audioUrl;
/**
 图片地址
 */
@property(nonatomic,copy) NSString *imageUrl;
@end

NS_ASSUME_NONNULL_END
