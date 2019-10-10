//
//  JKSatisfactionViewCell.h
//  JKIMSDKProject
//
//  Created by Jerry on 2019/10/9.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKDialogModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^ShowSubmitBtnBlock)(void);

@interface JKSatisfactionViewCell : UITableViewCell

@property (nonatomic,strong)JKDialogModel *model;

@property (nonatomic,copy) ShowSubmitBtnBlock submitBlock;
@end

NS_ASSUME_NONNULL_END
