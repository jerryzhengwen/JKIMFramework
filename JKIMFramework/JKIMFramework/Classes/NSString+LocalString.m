//
//  NSString+LocalString.m
//  JKIMSDKProject
//
//  Created by Jerry on 2019/4/3.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "NSString+LocalString.h"
#import "JKBundleTool.h"
@implementation NSString (LocalString)
-(NSString *)JK_localString {
    NSBundle *bundle = [JKBundleTool getCurrentLocaleLanguageBundle];
    if (!bundle) {
        NSString *string = [JKBundleTool initBundlePathWithResouceName:@"JK_LocalString" type:@"strings"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:string];
        if (dict.count) {
            return dict[self];
        }
    }
    NSString *value = NSLocalizedStringFromTableInBundle(self, @"JK_LocalString", bundle, nil);
    return value;
}
@end
