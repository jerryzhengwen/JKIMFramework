//
//  UUMessageFrame.m
//  UUChatDemoForTextVoicePicture
//
//  Created by zzx on 2019/3/12.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKMessageFrame.h"
#import "JKDialogModel.h"
#import "JKRichTextStatue.h"
#import "JKIM_YYWebImage.h"
#import "UIView+JKFloatFrame.h"

@interface JKMessageFrame()

@end

@implementation JKMessageFrame

- (void)setMessage:(JKDialogModel *)message{
    
    _message = message;
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    // 1、计算时间的位置
//    if (_showTime){
        CGFloat timeY = JKChatMargin;
        CGSize timeSize = [_message.time sizeWithFont:JKChatTimeFont constrainedToSize:CGSizeMake(300, 100) lineBreakMode:NSLineBreakByWordWrapping];

        CGFloat timeX = (screenW - timeSize.width) / 2;
        _timeF = CGRectMake(timeX, timeY, timeSize.width + JKChatTimeMarginW, timeSize.height + JKChatTimeMarginH);
//    }
    
    
    // 2、计算头像位置
    CGFloat iconX = JKChatMargin;
    if (_message.whoSend == JK_Visitor) {
        iconX = screenW - JKChatMargin - JKHeaderImageWH;
    }
    CGFloat iconY = CGRectGetMaxY(_timeF) + JKChatMargin;
    _iconF = CGRectMake(iconX, iconY, JKHeaderImageWH, JKHeaderImageWH);
    
    // 3、计算ID位置
    _nameF = CGRectMake(iconX, iconY+JKHeaderImageWH, JKHeaderImageWH, 20);
    
    // 4、计算内容位置
    CGFloat contentX = CGRectGetMaxX(_iconF)+JKChatMargin;
    CGFloat contentY = iconY;
   
    //根据种类分
    CGSize contentSize;
    switch (_message.messageType) {
        case JKMessageWord:
            contentSize = [self jiSuanMessageHeigthWithModel:message message:message.content font:JKChatContentFont];
 
            if ([message.content containsString:@"\r\n"] && message.whoSend != JK_Visitor) {
                contentSize.width = JKChatContentW;
            }
            
            break;
        case JKMessageImage:
            contentSize = CGSizeMake(message.imageWidth, message.imageHeight);
            
//            [self downloadImageWithModel:message point:CGPointMake(contentX, contentY) messageFrame:self];
            
            break;
        case JKMessageVedio:
            contentSize = CGSizeMake(120, 20);
            break;
        default:
            break;
    }
    if (_message.whoSend == JK_Visitor) {
        contentX = iconX - contentSize.width  - JKChatMargin;
    }
    _contentF = CGRectMake(contentX, contentY, contentSize.width + JKChatContentRight, contentSize.height );
    
    _cellHeight = MAX(CGRectGetMaxY(_contentF), CGRectGetMaxY(_nameF))  + JKChatMargin;
    
}

- (CGSize )jiSuanMessageHeigthWithModel:(JKDialogModel *)model message:(NSString *)message font:(UIFont *)font{
    if (!message.length) {
        return CGSizeZero;
    }
    
    JKRichTextStatue * richText = [[JKRichTextStatue alloc] init];
    richText.text = message;
    CGSize size = [self getAttributedStringHeightWithText:richText.attributedText andWidth:JKChatContentW andFont:font];
    
    model.imageHeight = size.height;
    if (!model.imageWidth) {
        model.imageWidth = size.width;
    }
    return size;
}
/**
 *  计算富文本的高度
 */
-(CGSize)getAttributedStringHeightWithText:(NSAttributedString *)attributedString andWidth:(CGFloat)width andFont:(UIFont *)font{
    static UITextView *stringLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{//生成一个同于计算文本高度的label
        stringLabel = [[UITextView alloc] init];
        stringLabel.textContainerInset = UIEdgeInsetsMake(JKChatContentTop, JKChatContentLeft, JKChatContentBottom, JKChatContentRight );
        stringLabel.font = font;
    });
    
    stringLabel.attributedText = attributedString;
    CGSize size = [stringLabel sizeThatFits:CGSizeMake(width, 0)];
    
    return size;
}


@end
