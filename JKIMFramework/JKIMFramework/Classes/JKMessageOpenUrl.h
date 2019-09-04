//
//  JKMessageOpenUrl.h
//  JKIMSDKProject
//
//  Created by Jerry on 2019/9/4.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MessageOpenUrl <NSObject>

/**
 自定义实现 点击超媒体消息链接跳转的操作

 @param URLString 链接字符串
 */
-(void)JK_hyperMediaMessageOpenURL:(NSString *)URLString;

/**
 聊天消息中的链接点击事件的监听

 @param urlString 消息内容中的url
 */
- (void)JK_messageOpenURL:(NSString *)urlString;

@end
@interface JKMessageOpenUrl : NSObject
@property (nullable,weak)id <MessageOpenUrl> delegate;

+(instancetype)sharedOpenUrl;
/**
 聊天消息中的文字点击事件

 @param URLString 文字点击的事件
 */
-(void)JK_ClickHyperMediaMessageOpenUrl:(NSString *)URLString;
/**
 聊天消息中的链接监听

 @param URLString 消息中的URL
 */
-(void)JK_ClickMessageOpenUrl:(NSString *)URLString;
@end

NS_ASSUME_NONNULL_END
