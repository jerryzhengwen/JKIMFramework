//
//  NSString+LocalString.h
//  JKIMSDKProject
//
//  Created by Jerry on 2019/4/3.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (LocalString)

/**
 从Strings读取字符串

 @return 当前String里的文件
 */
-(NSString *)JK_localString;
@end

NS_ASSUME_NONNULL_END
