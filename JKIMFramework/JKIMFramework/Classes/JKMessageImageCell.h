//
//  JKMessageImageCell.h
//  JKIMSDKProject
//
//  Created by Jerry on 2019/11/15.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKMessageContent.h"
@class JKMessageFrame;
@class JKMessageImageCell;

NS_ASSUME_NONNULL_BEGIN

@protocol JKMessageImageCellDelegate <NSObject>
@optional
- (void)cellCompleteLoadImage:(JKMessageImageCell *)cell;

-(void)cellCompleteLoadImgeUrl:(NSString *)imgUrl;

@end



@interface JKMessageImageCell : UITableViewCell
/** 时间的Label */
@property (nonatomic, retain)UILabel *labelTime;
/** 坐席名称的Label */
@property (nonatomic, retain)UILabel *nameLabel;


@property (nonatomic, retain)JKMessageContent *btnContent;

@property (nonatomic, retain)JKMessageFrame *messageFrame;

@property (nonatomic, assign)id<JKMessageImageCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
