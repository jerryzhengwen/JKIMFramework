//
//  JKSatisfactionViewController.h
//  JKIMSDKProject
//
//  Created by Jerry on 2019/4/19.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^ReturnMessageBlock)(NSString *message);

@interface JKSatisfactionViewController : JKBaseViewController

@property (nonatomic,copy)ReturnMessageBlock returnMessageBlock;

@end

NS_ASSUME_NONNULL_END
