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
#import "JKENUMObject.h"

@class JKMessage;
@class JKDialogeContentManager;

typedef void (^RobotMessageBlock)(JKMessage * _Nullable message,int count);

typedef void (^JKGetSatisFactionBlock)(id _Nullable result);

typedef void(^JKInItDialogueBlock)(NSDictionary *blockDict);

@protocol ConnectCenterDelegate<NSObject>
@required
/**
 收到消息

 @param message 消息
 */
- (void)receiveMessage:(JKMessage *_Nullable)message;
/**
 收到新的坐席消息

 @param message message
 */
@required
- (void)receiveNewListChat:(JKMessage *_Nullable)message;


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
 未读数
 */
@property (nonatomic,assign,readonly)NSInteger unreadCount;


/**
 机器人消息回调
 */
@property (nonatomic, copy) RobotMessageBlock robotMessageBlock;

@property (nonatomic,copy) JKGetSatisFactionBlock satisfactionBlock;
/**
 此时的连接状态
 */
@property (nonatomic,assign) JKSocketState socketState;

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

-(void)getSatisfactionWithBlock:(JKGetSatisFactionBlock)satisfactionBlock;

-(void)submitSatisfactionWithDict:(NSDictionary *)dict Block:(JKGetSatisFactionBlock)satisfactionBlock;

-(void)initDialogeWithBlock:(JKInItDialogueBlock)block;
/**
 接收到对话的message

 @param message JKMessage
 */
- (void)receiveMessage:(JKMessage *)message;


/**
 收到对话的邀请消息

 @param message JkMessage
 */
-(void)receiveInvitation:(JKMessage *)message;

/**
 查询数据
 
 @param selectKays selectKays 数组高级排序（数组里存放实体中的key，顺序按自己需要的先后存放即可），实体key来排序
 @param isAscending 升序降序
 @param filterString 查询条件
 */
- (NSMutableArray *)selectEntity:(NSArray *)selectKays ascending:(BOOL)isAscending filterString:(NSString *)filterString;


/**
 消息已读
 */
- (void)readMessageFromId:(NSString *)fromId;

/**
 退出登录
 */
- (void)exitSockectConnecting;
@end

NS_ASSUME_NONNULL_END
