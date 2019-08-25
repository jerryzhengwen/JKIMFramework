//
//  JKBaseViewController.h
//  JKIMSDKProject
//
//  Created by Jerry on 2019/4/19.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+JKFloatFrame.h"
NS_ASSUME_NONNULL_BEGIN

@interface JKBaseViewController : UIViewController
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic, strong)UILabel *titleLabel;

@property (nonatomic,strong)UIButton *endDialogBtn;
/** 获取图片资源路径 */
@property (nonatomic,copy)NSString *imageBundlePath;

/** 整体数组的DataArray */
@property(nonatomic, strong)NSMutableArray *dataFrameArray;
/**
 刷新项的refreshQ
 */
@property (nonatomic,strong)NSOperationQueue *refreshQ;

/** 创建返回按钮 */
- (void)createBackButton;
/** 创建RightButton */
- (void)createRightButton;
/**
 导航栏中间的坐席头像
 */
- (void)createCenterImageView;
@end

NS_ASSUME_NONNULL_END
