//
//  JKRichTextStatue.h
//  TestSDK
//
//  Created by Jerry on 2019/3/18.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#define   JK_URlREGULAR @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(((http[s]{0,1}|ftp)://|)((?:(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d)))\\.){3}(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d))))(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"

#define   JK_PHONENUMBERREGLAR @"0?(13|14|15|17|18|19)[0-9]{9}"
NS_ASSUME_NONNULL_BEGIN

@interface JKRichTextStatue : NSObject
@property(nonatomic,copy) NSString *text;
@property(nonatomic,copy) NSAttributedString *attributedText;

+(BOOL)returnContainEmojiStr:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
