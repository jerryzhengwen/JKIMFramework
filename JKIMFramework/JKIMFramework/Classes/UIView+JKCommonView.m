//
//  UIView+JKCommonView.m
//  JKIMSDKProject
//
//  Created by Jerry on 2019/11/4.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "UIView+JKCommonView.h"
#import "JKDialogueHeader.h"
@implementation UIView (JKCommonView)
/**
 适配8.0，9.0及以下的字体需要适配。

 @param size 字体的大小
 @return 返回所需要的字体
 */
-(UIFont *)getFontWithSize:(CGFloat)size {
    UIFont * font;
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 9.0) {
        font =  [UIFont systemFontOfSize:size];
    }else {
        font = [UIFont fontWithName:@"PingFang-SC-Regular" size:size];
    }
    return font;
}
-(UIButton *)createRegularButtonWithTitle:(NSString *)title size:(CGFloat)size {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [self getFontWithSize:size];
    return button;
}
-(UITextView *)createRegularTextViewWithTitle:(NSString *)title size:(CGFloat)size {
    UITextView * textView = [[UITextView alloc] init];
    textView.text = title;
    textView.editable = NO;
    textView.font = [self getFontWithSize:size];
    textView.textColor = UIColorFromRGB(0x3E3E3E);
    return textView;
}
-(UILabel *)createRegularLabelWithTitle:(NSString *)title size:(CGFloat)size {
    UILabel * label = [[UILabel alloc] init];
    label.text = title;
    label.font = [self getFontWithSize:size];
    label.textColor = UIColorFromRGB(0x3E3E3E);
    return label;
}
-(UIView *)createBackView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
- (BOOL) isEmpty:(NSString *) str {
    
    if (!str) {
        return true;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
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
