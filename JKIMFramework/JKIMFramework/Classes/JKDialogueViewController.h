//
//  JKDialogueViewController.h
//  JKIMSDKProject
//
//  Created by zzx on 2019/3/12.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKBaseViewController.h"
#import "JKHotMessageCell.h"
#import "JKAssoiateView.h"
#import "JKSatisfactionModel.h"
#import "JKSuckerView.h"
#import "JKUnSolveView.h"
#define BottomToolHeight 56

NS_ASSUME_NONNULL_BEGIN


@interface JKDialogueViewController : JKBaseViewController

@property(nonatomic,strong)JKAssoiateView *assoiateView;
/** 吸盘 */
@property(nonatomic,strong)JKSuckerView *suckerView;

/**
 点踩的view
 */
@property(nonatomic,strong)JKUnSolveView *unSolveView;

/** 是否需要重新带入问题展示 */
@property(nonatomic,assign)BOOL isNeedResend;
/** 是否排队，改变tableview的表尾 */
@property(nonatomic,assign)BOOL isLineUp;

/**
 用户的浏览轨迹
 */
@property(nonatomic,copy) NSString *scanPathDate;
@end

NS_ASSUME_NONNULL_END
