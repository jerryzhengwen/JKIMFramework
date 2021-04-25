//
//  UIView+JKCommonView.h
//  JKIMSDKProject
//
//  Created by Jerry on 2019/11/4.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (JKCommonView)
-(UIButton *)createRegularButtonWithTitle:(NSString *)title size:(CGFloat)size;
-(UITextView *)createRegularTextViewWithTitle:(NSString *)title size:(CGFloat)size;

-(UILabel *)createRegularLabelWithTitle:(NSString *)title size:(CGFloat)size;
-(UIView *)createBackView;
-(UIFont *)getFontWithSize:(CGFloat)size;
/**
判断字符串是否全部为空

 @param str p字符串
 @return 字符串是否全部为空
 */
- (BOOL) isEmpty:(NSString *) str;
/**
 计算字符串的宽度

 @param aString 字符串
 @param font 字体大小
 @param labelSize 字符串最大的宽度
 @return 真实的宽度
 */
CGSize countStringWordWidth(NSString *aString,UIFont * font, CGSize labelSize);
@end

NS_ASSUME_NONNULL_END
