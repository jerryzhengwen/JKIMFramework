//
//  JKDialogModel.m
//  JKIMSDKProject
//
//  Created by Jerry on 2019/3/13.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKDialogModel.h"
#import <UIKit/UIKit.h>
#import "JKRichTextStatue.h"


/** 最大的内容宽度*/
#define MaxContentWidth [UIScreen mainScreen].bounds.size.width - 170

@implementation JKDialogModel

- (void)setMessage:(NSString *)message{
    _message = message;
    
    JKRichTextStatue * richText = [[JKRichTextStatue alloc] init];
    richText.text = message;
    
    CGSize size = [self getAttributedStringHeightWithText:richText.attributedText andWidth:MaxContentWidth andFont:[UIFont systemFontOfSize:14]];
    
    self.imageHeight = size.height;
    if (!self.imageWidth) {
        self.imageWidth = size.width;
    }
    
    
}

/**
 *  计算富文本的高度
 */
- (CGSize)getAttributedStringHeightWithText:(NSAttributedString *)attributedString andWidth:(CGFloat)width andFont:(UIFont *)font {
    static UITextView *stringLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{//生成一个同于计算文本高度的label
        stringLabel = [[UITextView alloc] init];
        stringLabel.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5 );
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        stringLabel.font = font;
    });
    stringLabel.attributedText = attributedString;
    CGSize size = [stringLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    
    return size;
}


- (void)setTime:(NSString *)time{
    NSTimeInterval interval    =[time doubleValue] / 1000;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    
    //获取当前的系统时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *  locationString = [dateformatter stringFromDate:senddate];
    
    NSString * monthDay  =[dateString componentsSeparatedByString:@" "][0];
    if ([locationString isEqualToString:monthDay]) {
        NSString *hours = [dateString componentsSeparatedByString:@" "][1];
        _time = [hours substringToIndex:hours.length - 3];
    }else {
        _time = [dateString substringToIndex:time.length - 3];
    }
}

CGSize countStringWordWidth(NSString *aString,UIFont * font, CGSize labelSize) {
    
    CGSize size =[aString
                  boundingRectWithSize:labelSize
                  options:NSStringDrawingUsesLineFragmentOrigin
                  attributes:@{NSFontAttributeName:font}
                  context:nil].size;
    return size;
}


@end