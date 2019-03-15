//
//  JKDialogueSetting.m
//  JKIMSDKProject
//
//  Created by zzx on 2019/3/12.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKDialogueSetting.h"

@implementation JKDialogueSetting

+ (instancetype)sharedSetting {
    static JKDialogueSetting *setting;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        setting = [[JKDialogueSetting alloc]init];
    });
    return setting;
}



@end
