//
//  JKENUMObject.h
//  JKIMSDK
//
//  Created by Jerry on 2019/3/11.
//  Copyright © 2019 zzx. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface JKENUMObject : NSObject
@end

/**
 消息的格式

 - JKMessageWord: 消息的格式
 */
typedef NS_ENUM(NSInteger, JKMessageType) {
    JKMessageWord = 0, // 文字
    JKMessageImage, // 图片
    JKMessageAudio, //语音
    JKMessageVedio, //视频
    JKMessageHotMsg,//热点问题
    JKMessageImageText, //图文
    JKMessageFAQImage,//机器人的图片
    JKMessageFAQImageText,//机器人的图文
    JKMessageClarify,//澄清问题(类似于热点问题)
};

/**
 消息的发送状态
 */
typedef NS_ENUM(NSInteger, JKMessageReturnType) {
    JKMessageReturnError = 0,// 失败
    JKMessageReturnSuccess,  // 成功
    JKMessageReturnning,     // 发送中
};

typedef NS_ENUM(NSInteger ,JKMsgSource) {
    JK_Visitor = 0,          //访客
    JK_Customer = 1,         //顾问
    JK_Roboter = 2,          //机器人
    JK_SystemMark = 3,       //系统提示
    JK_SystemMarkShow = 4,
    JK_Other,
};

typedef NS_ENUM(NSInteger,JKMsgSendType) {
    JK_SocketMSG = 0,
    JK_HttpMSG = 1,
    JK_KeepMSG = 2,
    JK_OtherMSG,
};
typedef NS_ENUM(NSInteger,JKSocketState) {
    JK_SocketConnecting = 0,//正在连接
    JK_SocketConnectOnline = 1, //连接在线
    JK_SocketConnectOffline = 2, //连接离线
    JK_SocketReConnet = 3, //连接正在重练
    JK_SocketConnectRefuse = 4, //连接拒绝
    JK_SocketConnectError = 5, //连接错误
    JK_SocketExit ,//退出链接
};
