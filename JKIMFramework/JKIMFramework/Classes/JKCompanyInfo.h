//
//  JKCompanyInfo.h
//  JKIMSDK
//
//  Created by Jerry on 2019/3/11.
//  Copyright © 2019 zzx. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKCompanyInfo : NSObject
/**
 得到当前公司的appKey和appSecret

 @param appKey 注册后台生成的appKey
 @param appId 注册后台生成的appSecret
 @return 当前对象本身
 */
- (instancetype)initWithAppKey:(NSString *)appKey appId:(NSString *)appId;
/**
 设置长链接的地址和服务器以及url的地址和服务器
 @param serverIP 服务器地址
 @param serverPort 服务器端口
 @param urlIP 接口地址
 @param urlPort 接口端口
 */
- (void)setDomainInfoWithServer:(NSString *)serverIP AndPort:(int)serverPort UrlServer:(NSString *)urlIP AndUrlPort:(NSString *)urlPort;
@end

NS_ASSUME_NONNULL_END
