//
//  JKAlertView.h
//  JKIMSDKProject
//
//  Created by Jerry on 2019/10/9.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickButtonBlock)(BOOL leftBtn);

@interface JKAlertView : UIView
/**
 标题
 */
@property (nonatomic,copy) NSString *title;
/**
 内容
 */
@property (nonatomic,copy) NSString *content;

/**
 左边按钮标题
 */
@property (nonatomic,copy) NSString *leftTitle;
/**
 右边按钮标题
 */
@property (nonatomic,copy) NSString *rightTitle;

@property (nonatomic,copy)ClickButtonBlock clickBlock;
@property (nonatomic,copy)NSString *needUpdate;

@end

NS_ASSUME_NONNULL_END
