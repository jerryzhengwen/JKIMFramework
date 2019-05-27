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

- (void)createBackButton;
- (void)backAction:(id)sender;
@end

NS_ASSUME_NONNULL_END
