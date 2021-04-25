//
//  JKSuckerView.h
//  JKIMSDKProject
//
//  Created by Jerry on 2020/1/10.
//  Copyright © 2020 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKSurcketModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickSuckerBlock)(JKSurcketModel *);

@interface JKSuckerView : UIScrollView

/**
 ScrollView 的子View
 */
@property (nonatomic,strong)NSMutableArray * surcketArr;
@property (nonatomic,copy)ClickSuckerBlock suckerBlock;
@end

NS_ASSUME_NONNULL_END
