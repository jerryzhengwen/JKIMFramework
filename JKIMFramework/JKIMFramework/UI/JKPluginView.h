//
//  JKPluginView.h
//  JKIMSDKProject
//
//  Created by Jerry on 2019/4/2.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ClickJKPluginBlock)(int);

NS_ASSUME_NONNULL_BEGIN

@interface JKPluginView : UIScrollView
@property (nonatomic,strong)NSArray *plugArray;
@property (nonatomic,copy) ClickJKPluginBlock clickBlock;

@end

NS_ASSUME_NONNULL_END
