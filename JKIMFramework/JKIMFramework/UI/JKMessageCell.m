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
#import "NSString+LocalString.h"
#import "UIView+JKFloatFrame.h"

@interface JKMessageCell ()<UITextViewDelegate>
{
    AVAudioPlayer *player;
    NSString *voiceURL;
    NSData *songData;
    
    UIView *headImageBackView;
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
        self.labelTime.textColor = [UIColor grayColor];
        self.labelTime.font = JKChatTimeFont;
        [self.contentView addSubview:self.labelTime];
        
        // 2、创建头像
        headImageBackView = [[UIView alloc]init];
        headImageBackView.layer.cornerRadius = 22;
        headImageBackView.layer.masksToBounds = YES;
        [self.contentView addSubview:headImageBackView];
        self.btnHeadImage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnHeadImage.layer.cornerRadius = 20;
        self.btnHeadImage.layer.masksToBounds = YES;
        [self.btnHeadImage addTarget:self action:@selector(btnHeadImageClick:)  forControlEvents:UIControlEventTouchUpInside];
        [headImageBackView addSubview:self.btnHeadImage];
        
        // 3、创建头像下标
        self.labelNum = [[UILabel alloc] init];
        self.labelNum.textColor = [UIColor grayColor];
        self.labelNum.textAlignment = NSTextAlignmentCenter;
        self.labelNum.font = JKChatTimeFont;
        [self.contentView addSubview:self.labelNum];
        
        // 4、创建内容
        self.btnContent = [[JKMessageContent alloc]init];
        self.btnContent.contentTV.font = JKChatContentFont;
        [self.contentView addSubview:self.btnContent];
        
//        self.btnContent = [JKMessageContent buttonWithType:UIButtonTypeCustom];
//        [self.btnContent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        self.btnContent.titleLabel.font = JKChatContentFont;
//        self.btnContent.titleLabel.numberOfLines = 0;
//        [self.btnContent addTarget:self action:@selector(btnContentClick)  forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:self.btnContent];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(JKAVAudioPlayerDidFinishPlay) name:@"VoicePlayHasInterrupt" object:nil];

    }
    return self;
}

//头像点击
- (void)btnHeadImageClick:(UIButton *)button{
    
    NSLog(@"点击了头像");
    
    if ([self.delegate respondsToSelector:@selector(headImageDidClick:userId:)])  {
        
    }
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
    
   
    
    // 1、设置时间
    self.labelTime.text = [self changeTheDateString:message.time];
    self.labelTime.frame = messageFrame.timeF;
    
    // 2、设置头像
    headImageBackView.frame = messageFrame.iconF;
    self.btnHeadImage.frame = CGRectMake(2, 2, JKHeaderImageWH-4, JKHeaderImageWH-4);
    if (message.whoSend == JK_Visitor) {
        
        NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
        NSString *filePatch = [bundlePatch stringByAppendingPathComponent:@"dialogue_list_visitor"];
        [self.btnHeadImage setImage:[UIImage imageWithContentsOfFile:filePatch] forState:UIControlStateNormal];
        
    }else{
        
        NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
        NSString *filePatch = [bundlePatch stringByAppendingPathComponent:@"dialogue_list_service"];
        [self.btnHeadImage setImage:[UIImage imageWithContentsOfFile:filePatch] forState:UIControlStateNormal];
    }
    
    // 3、设置下标
    self.labelNum.text = @"";
    if (messageFrame.nameF.origin.x > 160) {
        self.labelNum.frame = CGRectMake(messageFrame.nameF.origin.x - 50, messageFrame.nameF.origin.y + 3, 100, messageFrame.nameF.size.height);
        self.labelNum.textAlignment = NSTextAlignmentRight;
    }else{
        self.labelNum.frame = CGRectMake(messageFrame.nameF.origin.x, messageFrame.nameF.origin.y + 3, 80, messageFrame.nameF.size.height);
        self.labelNum.textAlignment = NSTextAlignmentLeft;
    }

    // 4、设置内容
    
    //prepare for reuse
//    [self.btnContent setTitle:@"" forState:UIControlStateNormal];
    self.btnContent.contentTV.text = @"";
    self.btnContent.voiceBackView.hidden = YES;
    self.btnContent.backImageView.hidden = YES;

    self.btnContent.frame = messageFrame.contentF;
    self.btnContent.contentTV.delegate = self;
    
    if (messageFrame.message.isRichText) {
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
        }else {
            NSString *clickString = @"JK_DialogueView_ClickRichText".JK_localString;
            NSRange range = [messageFrame.message.content rangeOfString:clickString];
            [contentStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
            [contentStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%@://",clickString] range:range];
        }
        [contentStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0, contentStr.length)];
        self.btnContent.contentTV.attributedText = contentStr;
    }else {
        
        self.btnContent.contentTV.text = messageFrame.message.content;
        JKRichTextStatue * richText = [[JKRichTextStatue alloc] init];
        richText.text = messageFrame.message.content;
        self.btnContent.contentTV.attributedText = richText.attributedText;
        
    }
    
    
    if (message.whoSend == JK_Visitor) {
        self.btnContent.isMyMessage = YES;
        self.btnContent.contentTV.textColor = [UIColor whiteColor];
        self.btnContent.contentTV.textContainerInset = UIEdgeInsetsMake(JKChatContentTop, JKChatContentLeft, JKChatContentBottom, JKChatContentRight);
         self.btnContent.contentTV.frame = CGRectMake(0, 0, messageFrame.contentF.size.width, messageFrame.contentF.size.height);
    }else{
        self.btnContent.isMyMessage = NO;
        self.btnContent.contentTV.textColor = [UIColor grayColor];
        self.btnContent.contentTV.textContainerInset = UIEdgeInsetsMake(JKChatContentTop, JKChatContentLeft, JKChatContentBottom, JKChatContentRight);
         self.btnContent.contentTV.frame = CGRectMake(5, 0, messageFrame.contentF.size.width, messageFrame.contentF.size.height);
    }

    switch (message.messageType) {
        case JKMessageWord:
            self.btnContent.backgroundImageView.hidden = NO;
            self.btnContent.contentTV.hidden = NO;
            self.btnContent.backgroundImageView.frame = CGRectMake(0, 0, messageFrame.contentF.size.width, messageFrame.contentF.size.height);
           
//            self.btnContent.contentTV.text = message.content;
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
//                    self.photoImageView.autoPlayAnimatedImage = YES;
                }
                
            }
            
            UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnContentClick)];
            [self.btnContent.backImageView addGestureRecognizer:tapRecognize];
        }
            break;
        case JKMessageVedio:
        {
            self.btnContent.voiceBackView.hidden = NO;
        }
            break;
            
        default:
            break;
    }
    
    //背景气泡图
    UIImage *normal;
    if (message.whoSend == JK_Visitor) {
        normal = [UIImage imageNamed:@"chatto_bg_normal"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22)];
    }
    else{
        normal = [UIImage imageNamed:@"chatfrom_bg_normal"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10)];
    }
    
    self.btnContent.backgroundImageView.image = normal;
    
    //先设置系统提示的Label，如果是，之后的f也就可以不用走了
    if (message.whoSend == JK_SystemMarkShow) {
        self.btnContent.systemMarkLabel.hidden = NO;
        self.btnContent.systemMarkLabel.frame = messageFrame.contentF;
        self.btnContent.systemMarkLabel.text = message.content;
        headImageBackView.hidden = YES;
        self.btnContent.contentTV.hidden = YES;
        self.btnContent.backImageView.hidden = YES;
        self.btnContent.backgroundImageView.hidden = YES;
        
        CGPoint center = self.btnContent.systemMarkLabel.center;
        center.y = messageFrame.contentF.size.height / 2;
        center.x = [UIScreen mainScreen].bounds.size.width / 2;
        self.btnContent.systemMarkLabel.center = center;
        self.labelTime.hidden = YES;
        return;
    }else{
        self.btnContent.systemMarkLabel.hidden = YES;
        headImageBackView.hidden = NO;
        self.labelTime.hidden = NO;
    }
}


#pragma -
#pragma mark - textView的代理
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction  API_AVAILABLE(ios(10.0)){
    if ([textView.text containsString:@"JK_DialogueView_ClickRichText".JK_localString] && self.messageFrame.message.isRichText) {
        if (self.richText) {
            self.richText();
        }
    }else if (self.messageFrame.message.isRichText) {
        NSString *clickText = [textView.text substringWithRange:characterRange];
        if (self.clickCustomer) {
            self.clickCustomer(clickText);
        }
    }else {
        NSString *clickText = [textView.text substringWithRange:characterRange];
        if (self.skipBlock) {
            self.skipBlock(clickText);
        }
    }
    return YES;
}


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
     NSString *date =    [NSDate stringLoacalDate];
    if ([date containsString:dateStr]) {
        dateStr = @"";
    }
    return [NSString stringWithFormat:@"%@ %@:%02d",dateStr,hour,(int)[lastDate minute]];
}
@end



