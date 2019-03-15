//
//  JKDialogModel.m
//  JKIMSDKProject
//
//  Created by Jerry on 2019/3/13.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKDialogModel.h"
#import <UIKit/UIKit.h>

/** 最大的内容宽度*/
#define MaxContentWidth [UIScreen mainScreen].bounds.size.width - 180

@implementation JKDialogModel

- (void)setContent:(NSString *)content{
    _content = content;
    
    
    if (_content.length > 0) {
        
        if (self.isRichText == YES) {
            
            CGSize contentHeight = countStringWordWidth([NSString stringWithFormat:@"%@",content], [UIFont systemFontOfSize:14], CGSizeMake(MaxContentWidth, MAXFLOAT));
            
            self.detailHeight = ceil(contentHeight.height +28);
            
        }else{
            CGSize contentHeight = countStringWordWidth([NSString stringWithFormat:@"%@",content], [UIFont systemFontOfSize:14], CGSizeMake(MaxContentWidth, MAXFLOAT));
            
            self.detailHeight = ceil(contentHeight.height +10);
        }
        
        
        
    }
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
