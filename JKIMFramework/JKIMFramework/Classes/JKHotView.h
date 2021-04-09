//
//  JKHotView.h
//  JKIMSDKProject
//
//  Created by Jerry on 2019/8/12.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKHotViewCell.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^GetHotMessageBlock)(NSString *);


@interface JKHotView : UIView <UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSArray *hotArray;

@property (nonatomic,copy)GetHotMessageBlock hotMsgBlock;

/** tableview澄清问题不可以点击 */
@property (nonatomic,assign)BOOL isClarify;
@end

NS_ASSUME_NONNULL_END
