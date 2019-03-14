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
    JKMessageImageText, //图文
};
