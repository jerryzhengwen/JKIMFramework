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
#import <objc/message.h>
#import "NSDate+Utils.h"


/** 最大的内容宽度*/
#define MaxContentWidth [UIScreen mainScreen].bounds.size.width - 170

@implementation JKDialogModel


+(JKDialogModel *)changeMsgTypeWithJKModel:(JKMessage *)model {
    JKMessage * objCopy = [[JKMessage alloc] init];
    JKDialogModel *objModel = [[JKDialogModel alloc]init];
    unsigned int count;
    
    objc_property_t * properties = class_copyPropertyList(object_getClass(objCopy), &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    
    for (unsigned int i = 0; i < count; i++) {
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString  stringWithCString:propertyName     encoding:NSUTF8StringEncoding]];
    }
    
    free(properties);
    
    for (int i = 0; i < count ; i++)
    {
        NSString *name=[propertyArray objectAtIndex:i];
        id value=[model valueForKey:name];
        [objModel setValue:value forKey:name];
        
    }
    
    return objModel;
}

- (void)setMessage:(NSString *)message{
    _message = message;
}

- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end
{
    if (!start) {
        self.showDateLabel = YES;
        return;
    }
    
    NSString *subStart = [start substringWithRange:NSMakeRange(0, 19)];
    NSDate *startDate = [NSDate dateFromString:subStart withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *subEnd = [end substringWithRange:NSMakeRange(0, 19)];
    NSDate *endDate = [NSDate dateFromString:subEnd withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //这个是相隔的秒数
    NSTimeInterval timeInterval = [startDate timeIntervalSinceDate:endDate];
    
    //相距5分钟显示时间Label
    if (fabs (timeInterval) > 5*60) {
        self.showDateLabel = YES;
    }else{
        self.showDateLabel = NO;
    }
    
}

//- (void)setTimeStr:(NSString *)timeStr{
//    _timeStr = [self changeTheDateString:[NSString stringWithFormat:@"%ld",timeStr.integerValue]];
//}

//"08-10 晚上08:09:41.0" ->
//"昨天 上午10:09"或者"2012-08-10 凌晨07:09"
- (NSString *)changeTheDateString:(NSString *)Str
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate* lastDate = [NSDate dateWithTimeIntervalSince1970:[Str doubleValue]/ 1000.0];
    
    NSString *dateStr;  //年月日
    NSString *period;   //时间段
    NSString *hour;     //时
    
//    if ([lastDate year]==[[NSDate date] year]) {
//        NSInteger days = [NSDate daysOffsetBetweenStartDate:lastDate endDate:[NSDate date]];
//        if (days <= 2) {
//            dateStr = [lastDate stringYearMonthDayCompareToday];
//        }else{
//            dateStr = [lastDate stringMonthDay];
//        }
//    }else{
        dateStr = [lastDate stringYearMonthDay];
//    }
    
    
    if ([lastDate hour]>=5 && [lastDate hour]<12) {
        period = @"AM";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]];
    }else if ([lastDate hour]>=12 && [lastDate hour]<=18){
        period = @"PM";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]-12];
    }else if ([lastDate hour]>18 && [lastDate hour]<=23){
        period = @"Night";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]-12];
    }else{
        period = @"Dawn";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]];
    }
//    return [NSString stringWithFormat:@"%@ %@ %@:%02d",dateStr,period,hour,(int)[lastDate minute]];
    return [NSString stringWithFormat:@"%@ %@:%02d",dateStr,hour,(int)[lastDate minute]];
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
    
    stringLabel.font = font;
    stringLabel.attributedText = attributedString;
    CGSize size = [stringLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    
    return size;
}


//- (void)setTime:(NSString *)time{
//    NSTimeInterval interval    =[time doubleValue] / 1000;
//    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *dateString       = [formatter stringFromDate: date];
//
//    //获取当前的系统时间
//    NSDate *  senddate=[NSDate date];
//    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"YYYY-MM-dd"];
//    NSString *  locationString = [dateformatter stringFromDate:senddate];
//
//    NSString * monthDay  =[dateString componentsSeparatedByString:@" "][0];
//    if ([locationString isEqualToString:monthDay]) {
//        NSString *hours = [dateString componentsSeparatedByString:@" "][1];
//        _time = [hours substringToIndex:hours.length - 3];
//    }else {
//        _time = [dateString substringToIndex:time.length - 3];
//    }
//}

CGSize countStringWordWidth(NSString *aString,UIFont * font, CGSize labelSize) {
    
    CGSize size =[aString
                  boundingRectWithSize:labelSize
                  options:NSStringDrawingUsesLineFragmentOrigin
                  attributes:@{NSFontAttributeName:font}
                  context:nil].size;
    return size;
}
//-(NSString *)time {
//    if (_time == nil) {
//        
//    }
//    return _timeStr
//}

@end
