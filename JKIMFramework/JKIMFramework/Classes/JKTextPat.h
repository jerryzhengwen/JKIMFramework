//
//  JKTextPat.h
//  TestSDK
//
//  Created by Jerry on 2019/3/18.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKTextPat : NSObject

/**
 匹配出来的文字
 */
@property(nonatomic,copy) NSString *text;
/**
 匹配原文中的rang范围
 */
@property(nonatomic,assign)NSRange range;
/**
 是否是特殊字符
 */
@property (nonatomic,assign) BOOL isSpecial;
/**
 是否是表情
 */
@property (nonatomic,assign) BOOL isEmotion;
@end

NS_ASSUME_NONNULL_END
