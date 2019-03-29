//
//  JKPUSKService.h
//  JKIMSDK
//
//  Created by Jerry on 2019/3/28.
//  Copyright © 2019 zzx. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKPUSKService : NSObject

/**
 注册相关推送

 @param launchingOption NSDictionary
 @param isProduction 生产YES  测试NO
 @param channelId 来源ID
 */
+ (void)setupWithOption:(NSDictionary *)launchingOption
       apsForProduction:(BOOL)isProduction
  withChannelId:(NSString *)channelId;

/**
 注册推送

 @param data deviceToken
 */
+(void)registerDeviceToken:(NSData *)data;
/**
 接收推送
 */
+(void)receiveJKPUSHService;
/**
 不需要接收推送
 */
+(void)unReceiveJKPUSHService;


@end

NS_ASSUME_NONNULL_END
