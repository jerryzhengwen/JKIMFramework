//
//  JKMessageOpenUrl.m
//  JKIMSDKProject
//
//  Created by Jerry on 2019/9/4.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKMessageOpenUrl.h"

@implementation JKMessageOpenUrl

+ (instancetype)sharedOpenUrl{
    static JKMessageOpenUrl *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JKMessageOpenUrl alloc]init];
    });
    return instance;
}
-(void)JK_ClickHyperMediaMessageOpenUrl:(NSString *)URLString {
    if (self.delegate && [self.delegate respondsToSelector:@selector(JK_hyperMediaMessageOpenURL:)]) {
        [self.delegate JK_hyperMediaMessageOpenURL:URLString];
    }
}
-(void)JK_ClickMessageOpenUrl:(NSString *)URLString {
    if (self.delegate && [self.delegate respondsToSelector:@selector(JK_messageOpenURL:)]) {
        [self.delegate JK_messageOpenURL:URLString];
    }
}
@end
