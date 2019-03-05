//
//  JKConnectCenter.h
//  JKIMSDK
//
//  Created by zzx on 2019/3/4.
//  Copyright © 2019 zzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ANMessage;
@class ANStream;

@protocol ConnectCenterDelegate<NSObject>
@optional

- (void)ANStream:(ANStream *_Nullable)sender didReceiveMessage:(ANMessage *)message;

@end


NS_ASSUME_NONNULL_BEGIN

@interface JKConnectCenter : NSObject



@property (nullable,weak)id <ConnectCenterDelegate> delegate;
/**
 长链接超时时间，默认10s
 */
@property (nonatomic,assign) float socketTimeOut;
/**
 请求接口超时时间，默认10s
 */
@property (nonatomic,assign) float urlTimeOut;
/**
 是否打印日志
 */
@property (nonatomic,assign) BOOL  isLog;
/**
 是否抛出异常
 */
@property (nonatomic,assign) BOOL  throwException;

/**
 返回单例本身

 @return 初始化当前单例
 */
+(instancetype)sharedJKConnectCenter;


/**
 验证后台所生成的appKey和appSecret

 @param appKey 注册后台生成的appKey
 @param appSecret 注册后台生成的appSecret
 */
- (void)initWithAppKey:(NSString *)appKey AppSecret:(NSString *)appSecret;

/**
 设置长链接的地址和服务器以及url的地址和服务器
 @param hostName 服务器地址
 @param serverPort 服务器端口
 @param urlHostName 接口地址
 @param urlPort 接口端口
 */
- (void)initWithServer:(NSString *)hostName AndPort:(int)serverPort UrlServer:(NSString *)urlHostName AndUrlPort:(NSString *)urlPort;
/*

是否打印日志和抛出异常

 @param isLog 默认不打印日志
 @param throwException 默认不抛异常

- (void)initOtherInformationWithLog:(BOOL)isLog ThrowException:(BOOL)throwException;

 设置socket默认链接时间以及接口的请求时长

 @param socketTimeOut 默认10s
 @param urlTimeOut 默认10s

- (void)setSocketTimeOut:(NSTimeInterval *)socketTimeOut urlTimeOut:(NSTimeInterval *)urlTimeOut; */
@end

NS_ASSUME_NONNULL_END
