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

typedef NS_ENUM(NSInteger, JKChatStatue) {
    JKStatueRobot = 0,
    JKStatueBussiness = 1, // 业务类型
};

@interface JKMessage : NSObject <NSCopying,NSMutableCopying>

@property(nonatomic,assign) JKMsgSource whoSend;
/**
 展示内容，展示的内容中，表情为文本替换 （否则无法正则表情）
 */
@property(nonatomic,copy) NSString *content;
/**
 发送内容 发送的内容中，表情实为后台所需的表情符号
 */
@property (nonatomic,copy) NSString *sendContent;
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
@property(nonatomic,copy) NSString *from;

/**
 坐席当前头像opImgUrl
 */
@property(nonatomic,copy) NSString *opImgUrl;
/**
 消息类型
 */
@property(nonatomic,assign) JKMessageType messageType;

@property(nonatomic,assign) JKChatStatue chatStatue;
/**
 语音地址
 */
@property(nonatomic,copy) NSString *audioUrl;

/**
 图片地址
 */
@property(nonatomic,copy) NSString *imageUrl;

/** 消息的ID*/
@property(nonatomic,copy) NSString *messageId;

/** 消息的发送状态*/
@property(nonatomic,assign) JKMessageReturnType messageReturnType;

/** 图片的数据*/
@property(nonatomic,copy) NSData  *imageData;
/** 发送的消息类型*/
@property(nonatomic,assign) JKMsgSendType msgSendType;
///名字
@property (nullable, nonatomic, copy) NSString *iconName;
///头像地址
@property (nullable, nonatomic, copy) NSString *iconUrl;
///是否是富文本
@property (nonatomic,assign) BOOL isRichText;
/**
 高度
 */
@property (nonatomic,assign) float imageHeight;

/** 宽度 */
@property (nonatomic,assign) float imageWidth;

/** 当前时间 */
@property (nonatomic,copy) NSString *time;

/**  在线坐席 */
@property (nonatomic,assign) int customerNumber;
/** 聊天状态 */
@property (nonatomic,assign) BOOL chatState;
/** 聊天者名字 */
@property (nonatomic,copy) NSString *chatterName;

@property (nonatomic,strong)NSArray *hotArray;

/**
 排队的位数
 */
@property (nonatomic,copy)NSString  *index;
@property (nonatomic,copy)NSString  *timeoutqueue;

/**
 此条消息是否支持点评
 */
@property (nonatomic,assign)BOOL isComments;
/**
 是否需要点评。0代表除多轮、问答库以外的答案不用点评；1代表多轮、问答库答案可以点评，但未点评；2代表用户已经点评（点赞）；3代表用户已经点评（点踩）
 */
@property (nonatomic,assign)int commentsStatus;
/**
 点击了解决的按钮
 */
@property (nonatomic,assign) BOOL isClickSolveBtn;

/**
 点击了未解决的按钮
 */
@property (nonatomic,assign) BOOL isClickUnSolveBtn;
///** 热点问题ID */
//@property (nonatomic,copy) NSString * hotId;
///** 标准答案ID  */
//@property (nonatomic,copy) NSString *standardQuestionId;
///** 热点问题 */
//@property (nonatomic,copy) NSString *question;
///** 热点问题排序 */
//@property (nonatomic,assign) int sort;
///** 来源ID  */
//@property (nonatomic,assign) int source;
/**
 消息发送了多久
 */
@property (nonatomic ,assign)int sendTime;
/**
 发送到服务器的失败次数
 */
@property (nonatomic, assign) int sendFailCount;
@end

NS_ASSUME_NONNULL_END
