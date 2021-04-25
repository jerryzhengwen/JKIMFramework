//
//  JKUnSolveView.h
//  JKIMSDKProject
//
//  Created by Jerry on 2021/3/25.
//  Copyright © 2021 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickUnSolveTipsBlock)(NSString *selectTips);

@interface JKUnSolveView : UIView
/**
 数据源
 */
@property (nonatomic,strong)NSArray *titleArr;

/**
 选择不满意的提示
 */
@property (nonatomic,copy)ClickUnSolveTipsBlock clickTipsBlock;
@end

NS_ASSUME_NONNULL_END
