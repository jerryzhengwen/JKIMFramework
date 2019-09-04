//
//  JKCustomer.h
//  JKIMSDKProject
//
//  Created by zzx on 2019/3/11.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKCustomer : NSObject
/**
 访客昵称 必填
 */
@property (nonatomic,copy)NSString *visitor_name;
/**
 访客id 必填
 */
@property (nonatomic,copy)NSString *visitor_id;
/**
 邮箱  非必填
 */
@property (nonatomic,copy)NSString *email;
/**
 电话  必填
 */
@property (nonatomic,copy)NSString *mobile_phone;
/// qq 非必填
@property (nonatomic,copy)NSString *qq;
@end

NS_ASSUME_NONNULL_END
