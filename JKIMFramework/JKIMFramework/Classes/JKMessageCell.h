//
//  UUMessageCell.h
//  UUChatDemoForTextVoicePicture
//
//  Created by zzx on 2019/3/12.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKMessageContent.h"
#import "JKMsgSendStatusView.h"
@class JKMessageFrame;
@class JKMessageCell;

typedef void(^ClickRichText)(void);
typedef void(^ClickSkipBlock)(NSString *);
typedef void(^ClickCustomer)(NSString *);
typedef void(^ClickLineUpBlock)(void);
typedef void(^ClickSendMsgBlock)(NSString *);
//点解决、未解决键盘消失
typedef void(^DisMissKeyBoardBlock)(void);
//点击解决、未解决按钮
typedef void(^ClickSolveBtnBlock)(BOOL clickSolveBtn,NSString*answer,NSString *messageId,NSString *content_id);


@protocol JKMessageCellDelegate <NSObject>
@optional
- (void)cellCompleteLoadImage:(JKMessageCell *)cell;

@end


@interface JKMessageCell : UITableViewCell <UITextViewDelegate>

/** 时间的Label */
@property (nonatomic, retain)UILabel *labelTime;
/** 坐席名称的Label */
@property (nonatomic, retain)UILabel *nameLabel;



@property (nonatomic, retain)UIImageView *lineView;

@property (nonatomic, retain)JKMessageContent *btnContent;

@property (nonatomic, retain)JKMessageFrame *messageFrame;

@property (nonatomic, assign)id<JKMessageCellDelegate>delegate;


/**
 点击富文本的block
 */
@property (nonatomic,copy) ClickRichText richText;

/**
 点击在线坐席
 */
@property (nonatomic,copy) ClickCustomer clickCustomer;
@property (nonatomic,copy) ClickSkipBlock skipBlock;
@property (nonatomic,copy) ClickLineUpBlock lineUpBlock;
/**
 键盘消失block
 */
@property (nonatomic,copy) DisMissKeyBoardBlock dissMissKeyBoardBlock;
/**
 点击解决、未解决按钮
 */
@property (nonatomic,copy) ClickSolveBtnBlock clickSolveBtn;
/**
 新的消息的发送类型
 */
@property (nonatomic,copy) ClickSendMsgBlock sendMsgBlock;
/**
 解决按钮
 */
@property (nonatomic,strong)UIButton *solveBtn;
/**
 未解决按钮
 */
@property (nonatomic,strong)UIButton *unSloveBtn;
@property (nonatomic,strong)JKMsgSendStatusView * sendStatusView;
@end

