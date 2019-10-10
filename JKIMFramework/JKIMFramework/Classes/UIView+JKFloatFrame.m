//
//  UIView+JKFloatFrame.m
//  JKIMSDKProject
//
//  Created by zzx on 2019/3/8.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "UIView+JKFloatFrame.h"
#import "JKDialogueHeader.h"
@implementation UIView (JKFloatFrame)


- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    if (isnan(size.width))
    {
        size.width = 0;
    }
    if (isnan(size.height))
    {
        size.height = 0;
    }
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)top
{
    
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
    
    CGRect newFrame = self.frame;
    newFrame.origin.y = top;
    self.frame = newFrame;
}

- (CGFloat)bottom
{
    
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    
    CGRect newFrame = self.frame;
    newFrame.origin.y = bottom - self.frame.size.height;
    self.frame = newFrame;
}

- (CGFloat)left
{
    
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
    
    CGRect newFrame = self.frame;
    newFrame.origin.x = left;
    self.frame = newFrame;
}

- (CGFloat)right
{
    
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    
    CGRect newFrame = self.frame;
    newFrame.origin.x = right - self.frame.size.width;
    self.frame = newFrame;
}

- (CGFloat)middleX
{
    
    return CGRectGetWidth(self.bounds) / 2.f;
}

- (CGFloat)middleY
{
    
    return CGRectGetHeight(self.bounds) / 2.f;
}

- (CGPoint)middlePoint
{
    
    return CGPointMake(CGRectGetWidth(self.bounds) / 2.f, CGRectGetHeight(self.bounds) / 2.f);
}
+(UIView *)createBackView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor blackColor];
    return view;
}



+(NSString *)returnImageUrlStringWith:(NSString *)searchText {
    //这个是用来匹配图片的url的   [a-zA-z]+://[^\"]*
    if (!searchText) {
        return @"";
    }
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"((https|http)?://).*(png|jpg|gif|jpeg)+" options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    if (result) {
        return  [searchText substringWithRange:result.range];
    }else {
        return @"";
    }
}


+(NSMutableArray *)returnImageViewWidthAndHeightWith:(NSString *)width AndHeight:(NSString *)height {
    NSMutableArray * resultArray = [NSMutableArray array];
    CGFloat cWidth = [width floatValue];
    CGFloat cHeight = [height floatValue];
    CGFloat halfWidth = [UIScreen mainScreen].bounds.size.width / 2.0;
    CGFloat halfHeight = [UIScreen mainScreen].bounds.size.height / 2.0;
    CGFloat resultHeight = 0;
    CGFloat resultWidth = 0;
    if (cWidth/cHeight > 1.0) {   //icon为42个像素，不能够低于icon，最少为42高度
        resultHeight = halfWidth * cHeight / cWidth;
        resultWidth = halfWidth;
        if (resultHeight < 42) {
            resultHeight = 42;
        }
    }else{
        if (42< cHeight && cHeight< halfHeight && cWidth <= halfWidth) {
            resultWidth = cWidth;
            resultHeight = cHeight;
        }else if (cHeight < 42) {
            resultHeight = 42;
            resultWidth = 42 * cWidth/cHeight;
        }else if (cWidth > halfWidth){
            
            resultWidth = halfWidth;
            resultHeight = cHeight * resultWidth / cWidth;
            
            if (resultHeight > halfHeight) {
                resultHeight = halfHeight;
                resultWidth = resultHeight *cWidth / cHeight;
            }
            
        }else {
            resultHeight = halfHeight;
            resultWidth  = cWidth *resultHeight/cHeight;
            if (resultWidth > halfWidth) {
                resultWidth = halfWidth;
                resultHeight = resultWidth *cHeight / cWidth;
            }
        }
    }
    [resultArray addObject:[NSString stringWithFormat:@"%f",resultWidth]];
    [resultArray addObject:[NSString stringWithFormat:@"%f",resultHeight]];
    return resultArray;
}
+(UILabel *)createRegularLabelWithTitle:(NSString *)title size:(CGFloat)size {
    UILabel *label = [[UILabel alloc] init];
    if ([title class] != [NSNull class]) {
        if (title.length) {
            label.text = title;
        }
    }
    label.textColor = UIColorFromRGB(0x3E3E3E);
    label.textAlignment = NSTextAlignmentLeft;
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 9.0) {
        label.font =  [UIFont systemFontOfSize:size];
    }else {
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:size];
    }
    return label;
}

@end
