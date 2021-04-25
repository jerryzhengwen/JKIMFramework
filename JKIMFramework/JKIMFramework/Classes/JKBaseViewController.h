//
//  JKBaseViewController.h
//  JKIMSDKProject
//
//  Created by Jerry on 2019/4/19.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+JKFloatFrame.h"
#import "JKAlertView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JKBaseViewController : UIViewController
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic, strong)UILabel *titleLabel;

@property (nonatomic,strong)UIButton *endDialogBtn;

@property (nonatomic,strong)UIImageView *imageView;
/** 整体数组的DataArray */
@property(nonatomic, strong)NSMutableArray *dataFrameArray;
/**
 刷新项的refreshQ
 */
@property (nonatomic,strong)NSOperationQueue *refreshQ;
/**
 弹出框
 */
@property (nonatomic,strong) JKAlertView *alertView;

/** 创建返回按钮 */
- (void)createBackButton;
/** 创建RightButton */
- (void)createRightButton;
/** 返回的事件 */
- (void)backAction;
/**
 导航栏中间的坐席头像
 */
- (void)createCenterImageView;
@end

NS_ASSUME_NONNULL_END
