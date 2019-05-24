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

@end

NS_ASSUME_NONNULL_END
