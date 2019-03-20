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
 获取CoreData数据库的文件地址
 
 @param modelName 注意是.xcdatamodeld的文件名
 */
+ (NSURL *)initBundlePathWithCoreDataWithModelName:(NSString *)modelName;
@end

NS_ASSUME_NONNULL_END
