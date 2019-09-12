//
//  JKSystemMarkLabel.h
//  JKIMSDKProject
//
//  Created by zzx on 2019/4/19.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKSystemMarkLabel : UILabel

@property (nonatomic, assign) IBInspectable CGFloat topEdge;
@property (nonatomic, assign) IBInspectable CGFloat leftEdge;
@property (nonatomic, assign) IBInspectable CGFloat bottomEdge;
@property (nonatomic, assign) IBInspectable CGFloat rightEdge;

@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;

@end

NS_ASSUME_NONNULL_END
