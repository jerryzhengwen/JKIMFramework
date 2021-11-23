//
//  JKIMSendHelp.h
//  JKIMSDKProject
//
//  Created by zzx on 2019/4/24.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKENUMObject.h"

NS_ASSUME_NONNULL_BEGIN
@class JKMessageFrame;
@class JKMessage;
typedef void(^CompleteBlock)(JKMessageFrame *messageFrame);

@interface JKIMSendHelp : NSObject

/**
 发送文本信息
 @param messageModel 至少包含一下几个信息
 isRichText、content、msgSendType、whoSend、roomId、chatId
 
 @param completeBlock 完成的回调
 */
+ (void)sendTextMessageWithMessageModel:(JKMessage *)messageModel completeBlock:(CompleteBlock)completeBlock;

+ (void)sendImageMessageWithImageData:(NSData *)imageData image:(UIImage *)image MessageModel:(JKMessage *)messageModel completeBlock:(CompleteBlock)completeBlock;

/// 判断网络后重发消息
/// @param messageModel 消息体
+(void)judgeNetThenSendTextMessageWithMessageModel:(JKMessage *)messageModel;
/**
 获取时间戳
 
 @return 当前的时间戳
 */
+ (NSString *)jk_getTimestamp;
@end

NS_ASSUME_NONNULL_END
