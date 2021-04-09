//
//  JKHotMessageCell.h
//  JKIMSDKProject
//
//  Created by Jerry on 2019/8/12.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKDialogModel.h"
#import "JKHotView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JKHotMessageCell : UITableViewCell

@property (nonatomic,strong)JKDialogModel *model;

@property (nonatomic,strong)JKHotView *hotView;
@end

NS_ASSUME_NONNULL_END
