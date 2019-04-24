//
//  JKBundleTool.h
//  JKIMSDK
//
//  Created by zzx on 2019/3/20.
//  Copyright © 2019 zzx. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKBundleTool : NSObject
/**
 获取图片的bundle地址
 */
+ (NSString *)initBundlePathWithImage;
/**
 获取bundle地址
 */
+ (NSString *)initBundlePathWithResouceName:(NSString *)name type:(NSString *)type;

/**
 获取CoreData数据库的文件地址
 
 @param modelName 注意是.xcdatamodeld的文件名
 */
+ (NSURL *)initBundlePathWithCoreDataWithModelName:(NSString *)modelName;

/**
 获取当前系统语言包地址
 
 @return 返回语言包地址
 */
+ (NSBundle *)getCurrentLocaleLanguageBundle;


@end

NS_ASSUME_NONNULL_END
