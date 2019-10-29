//
//  UUMessageCell.h
//  UUChatDemoForTextVoicePicture
//
//  Created by zzx on 2019/3/12.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKMessageContent.h"
@class JKMessageFrame;
@class JKMessageCell;

typedef void(^ClickRichText)(void);
typedef void(^ClickSkipBlock)(NSString *);
typedef void(^ClickCustomer)(NSString *);

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

@end

