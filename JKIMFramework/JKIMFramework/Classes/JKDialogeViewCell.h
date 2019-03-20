//
//  JKDialogeViewCell.h
//  JKIMSDKProject
//
//  Created by Jerry on 2019/3/13.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKDialogModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickRichText)(void);
typedef void(^ClickSkipBlock)(NSString *);
typedef void(^ClickCustomer)(NSString *);
@interface JKDialogeViewCell : UITableViewCell
/**
 单个cell的数据源
 */
@property (nonatomic,strong)JKDialogModel *model;

/**
 点击富文本的block
 */
@property (nonatomic,copy) ClickRichText richText;
/**
 点击在线坐席
 */
@property (nonatomic,copy) ClickCustomer clickCustomer;
@property (nonatomic,copy) ClickSkipBlock skipBlock;
@end

NS_ASSUME_NONNULL_END
