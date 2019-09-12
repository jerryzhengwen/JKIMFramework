//
//  UUMessageFrame.m
//  UUChatDemoForTextVoicePicture
//
//  Created by zzx on 2019/3/12.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKMessageFrame.h"

#import "JKRichTextStatue.h"
#import "YYWebImage.h"
#import "UIView+JKFloatFrame.h"
#import "JKDialogueHeader.h"
@interface JKMessageFrame()

@end

@implementation JKMessageFrame



//- (void)setMessage:(JKDialogModel *)message{
//
//    _message = message;
//
//    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
//
//    // 1、计算时间的位置
//    CGFloat timeY = JKChatMargin;
//    _timeF = CGRectMake(0, timeY, screenW, 17);
//    CGFloat contentY = CGRectGetMaxY(_timeF);
//    CGFloat contentX = 0;
//    if (_message.whoSend !=JK_Visitor) {
//        _nameF = CGRectMake(24, CGRectGetMaxY(_timeF) + 30, screenW - 100, 20);
//        contentY = CGRectGetMaxY(_nameF) + 4;
//        contentX =  20;
//    }else {
//        contentY = contentY + 21;
//    }
//    //根据种类分
//    CGSize contentSize;
//    switch (_message.messageType) {
//        case JKMessageWord:
//            contentSize = [self jiSuanMessageHeigthWithModel:message message:message.content font:JKChatContentFont];
//
//            if ([message.content containsString:@"\r\n"] && message.whoSend != JK_Visitor) {
//                contentSize.width = JKChatContentW;
//            }
//
//            break;
//        case JKMessageImage:
//            contentSize = CGSizeMake(message.imageWidth, message.imageHeight);
//            break;
//        case JKMessageVedio:
//            contentSize = CGSizeMake(120, 20);
//            break;
//        default:
//            break;
//    }
//    if (_message.whoSend == JK_Visitor) {
//        contentX = screenW -20-contentSize.width - 44;
//    }
//
//    if (message.whoSend == JK_SystemMarkShow) {
//        _contentF = CGRectMake(0, 0, contentSize.width + 44, contentSize.height);
//        _cellHeight = CGRectGetMaxY(_contentF);
//    }else{
//        _contentF = CGRectMake(contentX, contentY, contentSize.width + 44, contentSize.height);
//        _cellHeight = MAX(CGRectGetMaxY(_contentF), CGRectGetMaxY(_nameF))  ;
//    }
//
//
//}

- (CGSize )jiSuanMessageHeigthWithModel:(JKDialogModel *)model message:(NSString *)message font:(UIFont *)font{
    if (!message.length) {
        return CGSizeZero;
    }
    
    JKRichTextStatue * richText = [[JKRichTextStatue alloc] init];
    richText.text = message;
    //再经过TextView中间过滤一次
    
    
    
    
    
    NSMutableAttributedString *attribute = [self praseHtmlStr:message];
    [attribute addAttributes:@{NSFontAttributeName: font} range:NSMakeRange(0, attribute.string.length)];
    
    CGSize size = [self getAttributedStringHeightWithText:attribute andWidth:JKChatContentW andFont:font];
    
    model.imageHeight = size.height;
    if (!model.imageWidth) {
        model.imageWidth = size.width;
    }
    return size;
}
- (NSMutableAttributedString *)praseHtmlStr:(NSString *)htmlStr {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    return attributedString;
}
/**
 *  计算富文本的高度
 */
-(CGSize)getAttributedStringHeightWithText:(NSAttributedString *)attributedString andWidth:(CGFloat)width andFont:(UIFont *)font{
    static UITextView *stringLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{//生成一个同于计算文本高度的label
        stringLabel = [[UITextView alloc] init];
        stringLabel.font = font;
    });
    
    stringLabel.attributedText = attributedString;
    CGSize size = [stringLabel sizeThatFits:CGSizeMake(width, 0)];
    CGSize ceilSize = CGSizeMake(ceil(size.width), ceil(size.height));
    return ceilSize;
}
//- (CGFloat)getStringHeightWithText:(NSString *)text font:(UIFont *)font viewWidth:(CGFloat)width {
//    // 设置文字属性 要和label的一致
//    NSDictionary *attrs = @{NSFontAttributeName :font};
//    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
//
//    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
//    // 计算文字占据的宽高
//    CGSize size = [text boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;
//    return  ceilf(size.height);
//}

@end