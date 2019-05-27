//
//  UIView+JKFloatFrame.h
//  JKIMSDKProject
//
//  Created by zzx on 2019/3/8.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (JKFloatFrame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;

@property (nonatomic, assign, readonly) CGFloat middleX;
@property (nonatomic, assign, readonly) CGFloat middleY;
@property (nonatomic, assign, readonly) CGPoint middlePoint;


+(NSString *)returnImageUrlStringWith:(NSString *)searchText;

+(NSMutableArray *)returnImageViewWidthAndHeightWith:(NSString *)width AndHeight:(NSString *)height;

@end

NS_ASSUME_NONNULL_END
