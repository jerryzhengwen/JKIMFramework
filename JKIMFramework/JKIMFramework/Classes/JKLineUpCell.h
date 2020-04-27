//
//  JKLineUpCell.h
//  JKIMSDKProject
//
//  Created by Jerry on 2019/11/4.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKMessageFrame.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^LineUPCustomerBlock)(void);
/**
 发送消息

 @param NSString 发送消息的内容
 */
typedef void(^LineUpSendMsgBlock)(NSString *);

@interface JKLineUpCell : UITableViewCell
@property (nonatomic,strong)JKMessageFrame *model;

@property (nonatomic,copy)LineUPCustomerBlock lineUpBlock;
@property (nonatomic,copy)LineUpSendMsgBlock sendMsgBlock;
@end

NS_ASSUME_NONNULL_END
