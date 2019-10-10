//
//  UUMessageCell.m
//  UUChatDemoForTextVoicePicture
//
//  Created by zzx on 2019/3/12.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKMessageCell.h"
#import "JKDialogModel.h"
#import "JKMessageFrame.h"
#import "JKAVAudioPlayer.h"
#import "JKImageAvatarBrowser.h"
#import "JKBundleTool.h"
#import "JKRichTextStatue.h"
#import "YYWebImage.h"
#import "NSDate+Utils.h"
#import "UIView+JKFloatFrame.h"
#import "JKDialogueHeader.h"
#import "RegexKitLite.h"
#import "JKMessageOpenUrl.h"
@interface JKMessageCell ()<UITextViewDelegate>
{
    AVAudioPlayer *player;
    NSString *voiceURL;
    NSData *songData;
    
//    UIView *headImageBackView;
}
@end

@implementation JKMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        // 1、创建时间
        self.labelTime = [[UILabel alloc] init];
        self.labelTime.textAlignment = NSTextAlignmentCenter;
        self.labelTime.textColor = UIColorFromRGB(0x9B9B9B);
        self.labelTime.font = JKChatTimeFont;
        [self.contentView addSubview:self.labelTime];
        
        // 3、创建头像下标
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor = UIColorFromRGB(0x9B9B9B);
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        if ([[UIDevice currentDevice].systemVersion doubleValue] < 9.0) {
           self.nameLabel.font =  [UIFont systemFontOfSize:14];
        }else {
            self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        }
        [self.contentView addSubview:self.nameLabel];
        
        // 4、创建内容
        self.btnContent = [[JKMessageContent alloc]init];
        self.btnContent.contentTV.font = JKChatContentFont;
        [self.contentView addSubview:self.btnContent];
    }
    return self;
}

- (void)btnContentClick{
    //play audio
    if (self.messageFrame.message.messageType == JKMessageVedio) {
        
    }
    //show the picture
    else if (self.messageFrame.message.messageType == JKMessageImage)
    {
        if (self.btnContent.backImageView) {
            [JKImageAvatarBrowser showImage:self.btnContent.backImageView];
        }
        if ([self.delegate isKindOfClass:[UIViewController class]]) {
            [[(UIViewController *)self.delegate view] endEditing:YES];
        }
    }
    // show text and gonna copy that
    else if (self.messageFrame.message.messageType == JKMessageWord)
    {
        
    }
}

//内容及Frame设置
- (void)setMessageFrame:(JKMessageFrame *)messageFrame{

    _messageFrame = messageFrame;
    JKDialogModel *message = messageFrame.message;
    
    self.btnContent.frame = _messageFrame.contentF;
    self.nameLabel.frame = _messageFrame.nameF;
    
    // 1、设置时间
    NSString * time = [NSDate getTimeStringWithIntervalString:message.time];
    self.labelTime.text = time;
    self.labelTime.frame = messageFrame.timeF;
    if (messageFrame.hiddenTime) {
        self.labelTime.text = @"";
    }
    // 2、设置名称
    if (message.whoSend !=JK_Visitor) {
        self.nameLabel.hidden = NO;
//        NSString * name = message.from.length?message.from:@"小广";
        self.nameLabel.text = @"智能客服-小广";
    }else {
        self.nameLabel.hidden = YES;
    }

    // 4、设置内容
    
    self.btnContent.contentTV.text = @"";
    self.btnContent.voiceBackView.hidden = YES;
    self.btnContent.backImageView.hidden = YES;

    self.btnContent.frame = messageFrame.contentF;
    self.btnContent.contentTV.delegate = self;
    
    BOOL isRichText = [self isRichTextWithContent:message.content];
    if (isRichText) {
        NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:messageFrame.message.content];
        if (messageFrame.message.customerNumber) {
            NSArray *customer = [messageFrame.message.content componentsSeparatedByString:@"\n"];
            NSMutableArray * removeArray = [NSMutableArray arrayWithArray:customer];
            [removeArray removeObject:@""];
            for (int i = 0; i < removeArray.count; i ++) {
                NSString *clickString = removeArray[i];
                NSRange range = [messageFrame.message.content rangeOfString:clickString];
                [contentStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
                [contentStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%@://",clickString] range:range];
            }
        self.btnContent.contentTV.attributedText = contentStr;
        }else {
            NSMutableAttributedString *contentStr = [self parseHtmlStr:message.content];
            //正则富文本的点击项
            NSString *bigString = [self returnSpanContent:message.content AndZhengZe:@"<a[^>]*>([^<]+)"];
            NSString *smallString = [self returnSpanContent:message.content AndZhengZe:@"<a[^>]*>"];
            NSString *content = [bigString stringByReplacingOccurrencesOfString:smallString withString:@""];
            NSRange range = [contentStr.string rangeOfString:content];
            [contentStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%@://",content] range:range];
        self.btnContent.contentTV.attributedText = contentStr;
        self.btnContent.contentTV.font = JKChatContentFont;
        self.btnContent.contentTV.linkTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGB(0xEC5642)};
        }
    }else {
        self.btnContent.contentTV.text = messageFrame.message.content;
        JKRichTextStatue * richText = [[JKRichTextStatue alloc] init];
        richText.text = messageFrame.message.content;
        self.btnContent.contentTV.attributedText = richText.attributedText;
    }
    
    CGFloat margin = 12;
//    if (message.whoSend == JK_Visitor) {
//        margin = 20;
//    }else{
//        margin = 24;
//    }
    self.btnContent.contentTV.frame = CGRectMake(margin, 0, messageFrame.contentF.size.width - 24, messageFrame.contentF.size.height);
    switch (message.messageType) {
        case JKMessageWord:
        self.btnContent.backgroundImageView.hidden = NO;
        self.btnContent.backgroundImageView.frame = CGRectMake(0, 0, messageFrame.contentF.size.width, messageFrame.contentF.size.height);
            break;
        case JKMessageImage:
        {
            self.btnContent.backImageView.hidden = NO;
            self.btnContent.contentTV.hidden = YES;
            self.btnContent.backgroundImageView.hidden = YES;
            self.btnContent.backImageView.userInteractionEnabled = YES;
            self.btnContent.userInteractionEnabled = YES;
            self.btnContent.backImageView.frame = CGRectMake(0, 0, messageFrame.contentF.size.width, messageFrame.contentF.size.height);
            if ([message.content containsString:@"http:"] ||[message.content containsString:@"https:"]) {
                
            [self downloadImageWithModelFrame:messageFrame button:self.btnContent];
                
            }else if([message.content containsString:@"gif"] || [message.content containsString:@"png"] ){
                
                self.btnContent.backImageView.yy_imageURL = [NSURL fileURLWithPath:message.content];
                if ([message.content containsString:@"gif"]) {

                }
                
            }
            
            UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnContentClick)];
            [self.btnContent.backImageView addGestureRecognizer:tapRecognize];
        }
            break;
            
        default:
            break;
    }
    
    //背景气泡图
    UIImage *normal;
    if (message.whoSend == JK_Visitor) {
        
        NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
        NSString *filePatch = [bundlePatch stringByAppendingPathComponent:@"chatto_bg_normal"];
        normal = [UIImage imageWithContentsOfFile:filePatch];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(16, 13, 16, 21)];
//        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 20, 10, 10) resizingMode:UIImageResizingModeStretch];
        self.btnContent.contentTV.textColor = [UIColor whiteColor];
    }
    else{
        self.btnContent.contentTV.textColor = UIColorFromRGB(0x3E3E3E);
        NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
        NSString *filePatch = [bundlePatch stringByAppendingPathComponent:@"chatfrom_bg_normal"];
        normal = [UIImage imageWithContentsOfFile:filePatch];
//        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 20, 10, 10)];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(16, 13, 16, 21)];
    }
    
    self.btnContent.backgroundImageView.image = normal;
    
    //先设置系统提示的Label，如果是，之后的f也就可以不用走了
    if (message.whoSend == JK_SystemMarkShow) {
        self.btnContent.systemMarkLabel.hidden = NO;
        self.btnContent.systemMarkLabel.frame = messageFrame.contentF;
        self.btnContent.systemMarkLabel.text = message.content;
        self.btnContent.contentTV.hidden = YES;
        self.btnContent.backImageView.hidden = YES;
        self.btnContent.backgroundImageView.hidden = YES;
        [self.btnContent.systemMarkLabel sizeToFit];
        CGPoint center = self.btnContent.systemMarkLabel.center;
        center.y = messageFrame.contentF.size.height / 2;
        center.x = [UIScreen mainScreen].bounds.size.width / 2;
        self.btnContent.systemMarkLabel.center = center;
        self.labelTime.hidden = YES;
        return;
    }else{
        self.btnContent.systemMarkLabel.hidden = YES;
        self.labelTime.hidden = NO;
    }
}

#pragma -
#pragma mark - textView的代理
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    NSString *clickString = self.messageFrame.message.content;
   
    
//    if (self.messageFrame.message.isRichText) {
//        if (self.richText) {
//            self.richText();
//        }
//    }else if (self.messageFrame.message.isRichText) {
//        NSString *clickText = [textView.text substringWithRange:characterRange];
//        if (self.clickCustomer) {
//            self.clickCustomer(clickText);
//        }
//    }else {
//        NSString *clickText = [textView.text substringWithRange:characterRange];
//        if (self.skipBlock) {
//            self.skipBlock(clickText);
//        }
//    }
    NSString *clickText = [textView.text substringWithRange:characterRange];
     NSArray *urlArray =  [clickText componentsMatchedByRegex:JK_URlREGULAR];
    if (urlArray.count) { //链接
        @try {
            [[JKMessageOpenUrl sharedOpenUrl] JK_ClickMessageOpenUrl:clickText];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
    }else { ///<a>标签
        NSString *clickStr = [textView.text substringWithRange:characterRange];
        NSString *regular = [NSString stringWithFormat:@"<a[^>]*>(%@)",clickStr];
        NSString *hrefStr = [self returnSpanContent:clickString AndZhengZe:regular];
//        NSArray *hrefUrl =  [hrefStr componentsMatchedByRegex:JK_URlREGULAR];
        if (!hrefStr) {
            return NO;
        }
        @try {
            NSString *url = [self returnSpanContent:hrefStr AndZhengZe:@"[a-zA-z]+://(.*?)\""];
            if (url.length > 0) {
                url = [url substringToIndex:url.length -1];
            }
            [[JKMessageOpenUrl sharedOpenUrl] JK_ClickHyperMediaMessageOpenUrl:url];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
    }
    return NO;
}
//-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
//    if (self.messageFrame.message.isRichText) {
//        if (self.richText) {
//            self.richText();
//        }
//    }else if (self.messageFrame.message.isRichText) {
//        NSString *clickText = [textView.text substringWithRange:characterRange];
//        if (self.clickCustomer) {
//            self.clickCustomer(clickText);
//        }
//    }else {
//        NSString *clickText = [textView.text substringWithRange:characterRange];
//        if (self.skipBlock) {
//            self.skipBlock(clickText);
//        }
//    }
//    return YES;
//}


/**
 下载图片
 */
- (void)downloadImageWithModelFrame:(JKMessageFrame *)modelFrame button:(JKMessageContent *)button{
    
//    __block UIImageView *sView = [[UIImageView alloc]init];
    [button.backImageView yy_setImageWithURL:[NSURL URLWithString:modelFrame.message.content] placeholder:nil options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (!error)  {
            NSMutableArray *sizeArr = [UIView returnImageViewWidthAndHeightWith:[NSString stringWithFormat:@"%lf",image.size.width] AndHeight:[NSString stringWithFormat:@"%lf",image.size.height]];

            modelFrame.message.imageWidth  = [[sizeArr objectAtIndex:0] floatValue];
            modelFrame.message.imageHeight = [[sizeArr objectAtIndex:1] floatValue];
            
            button.backImageView.image = image;
            
            modelFrame.contentF = CGRectMake(modelFrame.contentF.origin.x, modelFrame.contentF.origin.y, [[sizeArr objectAtIndex:0] floatValue], [[sizeArr objectAtIndex:1] floatValue]);

            modelFrame.cellHeight = MAX(CGRectGetMaxY(modelFrame.contentF), CGRectGetMaxY(modelFrame.nameF))  + JKChatMargin;

            if ([self.delegate respondsToSelector:@selector(cellCompleteLoadImage:)])  {

                [self.delegate cellCompleteLoadImage:self];
            }
        }
    }];
    
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    self.btnContent.contentTV.userInteractionEnabled = NO ;
    return NO;
}
//- (NSString *)changeTheDateString:(NSString *)Str
//{
//    NSString * time = [NSDate getTimeStringWithIntervalString:Str];
//    return time;
//    // 格式化时间
////    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
////    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
////    [formatter setDateStyle:NSDateFormatterMediumStyle];
////    [formatter setTimeStyle:NSDateFormatterShortStyle];
////    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
////
////    // 毫秒值转化为秒
////    NSDate* lastDate = [NSDate dateWithTimeIntervalSince1970:[Str doubleValue]/ 1000.0];
////
////    NSString *dateStr;  //年月日
////    NSString *period;   //时间段
////    NSString *hour;     //时
////    dateStr = [lastDate stringYearMonthDay];
////
////
////    if ([lastDate hour]>=5 && [lastDate hour]<12) {
////        period = @"AM";
////        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]];
////    }else if ([lastDate hour]>=12 && [lastDate hour]<=18){
////        period = @"PM";
////        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]-12];
////    }else if ([lastDate hour]>18 && [lastDate hour]<=23){
////        period = @"Night";
////        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]-12];
////    }else{
////        period = @"Dawn";
////        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]];
////    }
////     NSString *date =    [NSDate stringLoacalDate];
////    if ([date containsString:dateStr]) {
////        dateStr = @"";
////    }
////    return [NSString stringWithFormat:@"%@ %@:%02d",dateStr,hour,(int)[lastDate minute]];
//}




/**
 判断有没有<a>标签，如果有标签就代表着需要富文本点击

 @param content 内容
 @return Yes富文本 NO不是富文本
 */
-(BOOL)isRichTextWithContent:(NSString *)content {
    if (!content) {
        return NO;
    }
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<a[^>]*>([^<]+)" options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:content options:0 range:NSMakeRange(0, [content length])];
    if (result) {
        return YES;
    }else {
        return NO;
    }
}
- (NSMutableAttributedString *)parseHtmlStr:(NSString *)htmlStr {
    NSMutableAttributedString *attributedString;
    @try {
        attributedString  = [[NSMutableAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    } @catch (NSException *exception) {
        attributedString = [[NSMutableAttributedString alloc] initWithString:htmlStr];
    } @finally {
    }
   
    return attributedString;
}
//两次提取a标签用来提取<a> 2</a>中的值
-(NSString *)returnSpanContent:(NSString *)span AndZhengZe:(NSString *)pattern {
    if (!span) {
        return @"";
    }
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:span options:0 range:NSMakeRange(0, [span length])];
    if (result) {
        return  [span substringWithRange:result.range];
    }else {
        return @"";
    }
}
@end



