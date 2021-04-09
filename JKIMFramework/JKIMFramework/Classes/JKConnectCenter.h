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
#import "JKSurcketModel.h"
@class JKMessage;
@class JKDialogeContentManager;

typedef void (^RobotMessageBlock)(JKMessage * _Nullable message,int count);

typedef void (^JKGetSatisFactionBlock)(id _Nullable result,BOOL isSuccess);

typedef void(^JKInItDialogueBlock)(NSDictionary * _Nullable blockDict);

typedef void(^JKGetSimilarQuestionBlock)(id _Nonnull result);

typedef void(^JKSkipChatBlock)(BOOL);

typedef void(^JKGetEndChatBlock)(BOOL satisFaction);

typedef void(^JKLoadHistoryBlock)(NSArray<JKMessage *> *array);


/**
 初始化相关数据是否成功

 */
typedef void(^JKInitCompleteBlock)(BOOL);


@protocol ConnectCenterDelegate<NSObject>

-(void)receiveRobotRePlay:(JKMessage *_Nonnull)message;
/**
 收到热点问题的

 @param hotArray 热点问题的Array
 */
@required
-(void)receiveHotJKMessage:(JKMessage *_Nonnull)message;

@optional
-(void)getRoomHistory:(NSArray<JKMessage *> *_Nullable)messageArr;
@optional
/**
 底部吸盘的功能
 
 @param surcketArr 吸盘的arr数组
 */
-(void)getSurcketModelArr:(NSMutableArray<JKSurcketModel *> *_Nullable)surcketArr;
/**
 收到消息

 @param message 消息
 */
@required
- (void)receiveMessage:(JKMessage *_Nullable)message;
/**
 收到新的坐席消息

 @param message message
 */
@required
- (void)receiveNewListChat:(JKMessage *_Nullable)message;

/**
 context_id过期，重新发送

 @param content 需要重新发送的内容
 */
- (void)updateContextIDReSendContent:(NSString *_Nullable)content;
@required
/**
 取消排队成功
 */
- (void)receiveCancelLineUpMessage;

- (void)whetherHistoryRoomNeedUpdate;

/** 在对话的过程中更新用户信息*/
//- (void)updateVisitorInfoToCustomerChat;
@end


NS_ASSUME_NONNULL_BEGIN

@interface JKConnectCenter : NSObject

@property(nonatomic,copy) NSString *roomId;

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

@property (nonatomic,assign) BOOL isHttps;
/**
 机器人消息回调
 */
@property (nonatomic, copy) RobotMessageBlock robotMessageBlock;

@property (nonatomic,copy) JKGetSatisFactionBlock satisfactionBlock;

@property (nonatomic,copy) JKGetSimilarQuestionBlock similarBlock;
/** 此时的连接状态 */
@property (nonatomic,assign) JKSocketState socketState;
/** 是否进入的Block */
@property (nonatomic,copy) JKSkipChatBlock skipBlock;
@property (nonatomic,copy) NSString *chat_id;

@property (nonatomic,assign)BOOL isNeedResend;
/**
 用户的浏览轨迹
 */
@property (nonatomic,copy) NSString *scanPath;
/**
 返回单例本身

 @return 初始化当前单例
 */
+(instancetype)sharedJKConnectCenter;




-(void)checkoutInitCompleteBlock:(JKInitCompleteBlock) completeBlock;

-(void)getSimilarQuestion:(NSString *)question Block:(JKGetSimilarQuestionBlock)block;

-(void)getRobotQuestion:(JKMessage *)message;

/**
 初始化公司的相关信息
 */
-(void)checkoutInfoWithBlock:(JKSkipChatBlock)skipBlock;

/**
 验证所需要的公司信息和访客信息

 @param companyInfo 公司的信息Info
 @param customer 对接访客信息，没有访客信息传nil即可
 */
-(void)initWithCompanyInfo:(JKCompanyInfo *)companyInfo customer:(JKCustomer *)customer;

/** 发送消息 @param message 发送消息体 */
-(void)sendMessage:(JKMessage *)message;

/** 发送消息到房间，告诉坐席更新ID @param message 发送消息体 */
//-(void)upDateVisitorInfo:(JKMessage *)message;

-(void)receiveHistoryArray:(NSArray<JKMessage *> *)messageArr;

/** 发送机器人消息 */
-(void)sendRobotMessage:(JKMessage *)message robotMessageBlock:(RobotMessageBlock)robotMessageBlock;

- (void)receiveRobotOn:(NSString *)data;

-(void)getSatisfactionWithBlock:(JKGetSatisFactionBlock)satisfactionBlock;

-(void)submitSatisfactionWithDict:(NSDictionary *)dict Block:(JKGetSatisFactionBlock)satisfactionBlock;

-(void)initDialogeWithBlock:(JKInItDialogueBlock)block;

/**
 加载历史记录的Block

 @param block 历史记录的Block
 */
-(void)JK_LoadHistoryWithBlock:(JKLoadHistoryBlock)block;

/**
 结束对话收到满意度需要初始化一下context_id;
 */
-(void)initDialogeWIthSatisFaction;

/**
 结束对话的Block（以前假结束）
 @param block 结束对话
 */
-(void)getEndChatBlock:(JKGetEndChatBlock)block;
/**
 真的结束对话
 */
-(void)getReallyEndChat;
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
 热点消息的Array

 @param message 热点消息的JKMessage
 */
-(void)sendHotJKMessage:(JKMessage *)message;

/** 吸盘功能 @param message 吸盘的message */
-(void)sendJKSurketModelArr:(NSMutableArray<JKSurcketModel *> *)message;
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
/**
 用户信息同步 必填visitor_name、mobile_phone字段
 如果退出，传nil即可。
 @param customer 用户的基本信息
 */
-(void)JKIM_statueChangeWithCustomer:(JKCustomer *)customer;

/**
 获取context_id

 @return 获取context_id
 */
-(NSString *)JKIM_getContext_id;

-(void)reInitHistoryRoomWhetherUpdate;

-(void)needReSendContent:(NSString *)content;
/**
 获取未解决提示数组

 @return 获取未解决的反馈数组
 */
-(NSArray *)getUnsolveArr;
/**
 点赞或者点踩调用的接口

 @param dict 入参
 @param success 接口请求成功
 @param errorBlock 接口请求失败
 */
-(void)requestRobotCommentsWithPara:(NSMutableDictionary *)dict result:(void(^)(BOOL isSuccess,NSString *tips))success error:(void (^)(NSString * errorMsg))errorBlock;
@end

NS_ASSUME_NONNULL_END
