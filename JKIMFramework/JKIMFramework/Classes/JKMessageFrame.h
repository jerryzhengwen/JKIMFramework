//
//  UUMessageFrame.h
//  UUChatDemoForTextVoicePicture
//
//  Created by zzx on 2019/3/12.
//  Copyright © 2019 于飞. All rights reserved.
//

#define JKChatMargin    16       //间隔
#define JKHeaderImageWH 46       //头像宽高height、width


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
@property (nonatomic, assign) BOOL moveToLast;
@property (nonatomic, assign) BOOL hiddenTimeLabel;
/**
 满意度的context_id;
 */
@property (nonatomic, copy) NSString * context_id;
/**
 满意度的content
 */
@property (nonatomic, copy) NSString * content;
@property (nonatomic, strong) NSMutableArray  * soluteArr;
@property (nonatomic, strong) NSMutableArray  * satisArr;
/** 是否已经提交 */
@property (nonatomic, assign) BOOL isSubmit;
@property (nonatomic, assign) BOOL isFirstResign;
/** 点击了转人工按钮，这个按钮就不让再点 */
@property (nonatomic, assign) BOOL isClickOnce;
/**
 上一通对话
 */
@property (nonatomic, assign) BOOL isBeforeDialog;
@end
