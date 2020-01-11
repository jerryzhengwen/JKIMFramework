//
//  JKSurcketModel.h
//  JKIMSDK
//
//  Created by Jerry on 2020/1/10.
//  Copyright © 2020 zzx. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKSurcketModel : NSObject

@property(nonatomic,copy) NSString *isOpen;
/**
 名称
 */
@property(nonatomic,copy) NSString *name;

/**
 跳转链接。 为1是发送name，为2是发送链接
 */
@property(nonatomic,copy) NSString *pattern;

/**
 链接的url
 */
@property(nonatomic,copy) NSString *content;
@end

NS_ASSUME_NONNULL_END
