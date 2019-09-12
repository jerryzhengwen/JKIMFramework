//
//  JKDialogueViewController.h
//  JKIMSDKProject
//
//  Created by zzx on 2019/3/12.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKBaseViewController.h"
#import "JKHotMessageCell.h"
#import "JKAssoiateView.h"
#import "MJRefresh.h"

#define BottomToolHeight 54

NS_ASSUME_NONNULL_BEGIN

@interface JKDialogueViewController : JKBaseViewController

@property(nonatomic,strong)JKAssoiateView *assoiateView;

@end

NS_ASSUME_NONNULL_END
