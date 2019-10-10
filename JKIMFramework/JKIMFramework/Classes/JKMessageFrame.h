//
//  UUMessageFrame.h
//  UUChatDemoForTextVoicePicture
//
//  Created by zzx on 2019/3/12.
//  Copyright © 2019 于飞. All rights reserved.
//

#define JKChatMargin    12       //间隔
#define JKHeaderImageWH 46       //头像宽高height、width
#define JKChatContentW  [UIScreen mainScreen].bounds.size.width - 170    //内容宽度

#define JKChatTimeMarginW 15  //时间文本与边框间隔宽度方向
#define JKChatTimeMarginH 10  //时间文本与边框间隔高度方向

#define JKChatContentTop 0   //文本内容与按钮上边缘间隔
#define JKChatContentLeft 0  //文本内容与按钮左边缘间隔
#define JKChatContentBottom 0 //文本内容与按钮下边缘间隔
#define JKChatContentRight 0 //文本内容与按钮右边缘间隔


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JKDialogModel.h"

@interface JKMessageFrame : NSObject

@property (nonatomic, assign) CGRect nameF;
@property (nonatomic, assign) CGRect iconF;
@property (nonatomic, assign) CGRect timeF;
@property (nonatomic, assign) CGRect contentF;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, retain) JKDialogModel *message;
@property (nonatomic, assign) JKMessageType type;
@property (nonatomic, assign) BOOL hiddenTime;
@property (nonatomic, assign) BOOL moveToLast;
@end
