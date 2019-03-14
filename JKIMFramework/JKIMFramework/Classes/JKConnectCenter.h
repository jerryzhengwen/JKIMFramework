//
//  JKConnectCenter.h
//  JKIMSDK
//
//  Created by zzx on 2019/3/4.
//  Copyright © 2019 zzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKCompanyInfo.h"
#import "JKCustomer.h"

#import "JKMessage.h"
typedef void (^RobotMessageBlock)(JKMessage *message,int count);

@protocol ConnectCenterDelegate<NSObject>
@required
/**
 收到消息

 @param message 消息
 */
- (void)didReceiveMessage:(JKMessage *)message;
/**
 收到新的坐席消息

 @param message message
 */
- (void)receiveNewListChat:(JKMessage *)message;

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


@property (nonatomic,assign,getter=isRobotOn,readonly)BOOL robotOn;


/**
 机器人消息回调
 */
@property (nonatomic, copy) RobotMessageBlock robotMessageBlock;

/**
 返回单例本身

 @return 初始化当前单例
 */
+(instancetype)sharedJKConnectCenter;
/**
 验证所需要的公司信息和访客信息

 @param companyInfo 公司的信息Info
 @param customer 对接访客信息，没有访客信息传nil即可
 */
-(void)initWithCompanyInfo:(JKCompanyInfo *)companyInfo customer:(JKCustomer *)customer;

/**
 发送消息

 @param message 发送消息体
 */
-(void)sendMessage:(JKMessage *)message;

/**
 发送机器人消息
 */
-(void)sendRobotMessage:(JKMessage *)message robotMessageBlock:(RobotMessageBlock)robotMessageBlock;


- (void)receiveRobotOn:(NSString *)data;

@end

NS_ASSUME_NONNULL_END
