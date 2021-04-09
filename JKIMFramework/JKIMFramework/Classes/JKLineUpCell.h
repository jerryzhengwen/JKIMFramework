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
//点解决、未解决键盘消失
typedef void(^DisMissKeyBoardBlock)(void);
/**
 发送消息

 @param text 发送消息的内容
 */
typedef void(^LineUpSendMsgBlock)(NSString *text);
//点击解决、未解决按钮
typedef void(^ClickSolveBtnBlock)(BOOL clickSolveBtn,NSString*answer,NSString *messageId,NSString *content_id);
@interface JKLineUpCell : UITableViewCell
@property (nonatomic,strong)JKMessageFrame *model;

@property (nonatomic,copy)LineUPCustomerBlock lineUpBlock;
@property (nonatomic,copy)LineUpSendMsgBlock sendMsgBlock;
/**
 解决按钮
 */
@property (nonatomic,strong)UIButton *solveBtn;
/**
 未解决按钮
 */
@property (nonatomic,strong)UIButton *unSloveBtn;
/**
 点击事件回调
 */
@property (nonatomic,copy)ClickSolveBtnBlock clickBtnBlock;
/**
 键盘消失block
 */
@property (nonatomic,copy) DisMissKeyBoardBlock dissMissKeyBoardBlock;
@end

NS_ASSUME_NONNULL_END
