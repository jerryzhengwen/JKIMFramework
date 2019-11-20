//
//  JKDialogModel.h
//  JKIMSDKProject
//
//  Created by Jerry on 2019/3/13.
//  Copyright © 2019 于飞. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JKMessage.h"
#import "JKENUMObject.h"

//typedef NS_ENUM(NSInteger, JKSOLUTEBTN_Click) {
//    SOLUTEBTN_NONE = 0,
//    SOLUTEBTN_SOLVE = 1,
//    SOLUTEBTN_UNSOLVE = 2,
//};
//typedef NS_ENUM(NSInteger, JKSTARTBTN_Click) {
//    STARTBTN_NONE = -1,
//    STARTBTN_ONE = 0,
//    STARTBTN_TWO = 1,
//    STARTBTN_THREE = 2,
//    STARTBTN_FOUR = 3,
//    STARTBTN_FIVE = 4,
//};

NS_ASSUME_NONNULL_BEGIN
@interface JKDialogModel : JKMessage


/**
 内容
 */
@property (nonatomic,copy) NSString *message;
/**
 图片
 */
@property(nonatomic, strong)UIImage *imageIcon;

/**
 当前时间戳
 */
@property (nonatomic,copy) NSString *time;

/**
 UI展示的时间
 */
//@property (nonatomic,copy) NSString *timeStr;

/**
 是否是调用http 请求回复
 */
@property (nonatomic,assign) BOOL getHttpResult;

//@property (nonatomic, copy) NSString *iconUrl;

@property (nullable, nonatomic, copy) NSString *contentUrl;

//@property (nullable, nonatomic, copy) NSString *iconName;


/**
 在线坐席
 */
@property (nonatomic,assign) int customerNumber;


@property (nonatomic, assign) BOOL showDateLabel;

@property (nonatomic,assign) BOOL isSubmit;//是否已提交(满意度的)



- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end;


+(JKDialogModel *)changeMsgTypeWithJKModel:(JKMessage *)model;


@end

NS_ASSUME_NONNULL_END
