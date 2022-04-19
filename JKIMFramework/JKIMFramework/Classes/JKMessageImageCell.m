//
//  JKMessageImageCell.m
//  JKIMSDKProject
//
//  Created by Jerry on 2019/11/15.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKMessageImageCell.h"
#import "JKDialogueHeader.h"
#import "YYWebImage.h"
#import "MMImageBrower.h"
#import "JKMsgSendStatusView.h"

@interface JKMessageImageCell ()
@property (nonatomic,strong)JKMsgSendStatusView * sendStatusView;
@end

@implementation JKMessageImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor =JKBGDefaultColor;
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
        [self.contentView addSubview:self.btnContent];
        [self.contentView addSubview:self.sendStatusView];
    }
    return self;
}

- (void)btnContentClick{ //image的图片
    if (self.btnContent.backImageView.image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(resignKeyBoard)]) {
                [self.delegate resignKeyBoard];
            }
        MMImageBrower *img  =  [[MMImageBrower alloc] init];
        img.images = @[self.btnContent.backImageView.image];
        [img show];
        });
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
    if (messageFrame.hiddenTimeLabel) {
        self.labelTime.hidden = YES;
    }else {
        self.labelTime.hidden = NO;
    }
    // 2、设置名称
    if (message.whoSend !=JK_Visitor) {
        self.nameLabel.hidden = NO;
        self.nameLabel.text = message.from.length?message.from:@"智能客服-小广";
    }else {
        self.nameLabel.hidden = YES;
    }
    
    // 4、设置内容
    
    self.btnContent.voiceBackView.hidden = YES;
    self.btnContent.backImageView.hidden = YES;
    
    self.btnContent.frame = messageFrame.contentF;
    self.btnContent.backImageView.hidden = NO;
    self.btnContent.contentTV.hidden = YES;
    self.btnContent.backgroundImageView.hidden = YES;
    self.btnContent.backImageView.userInteractionEnabled = YES;
    self.btnContent.userInteractionEnabled = YES;
    self.btnContent.backImageView.frame = CGRectMake(0, 0, messageFrame.contentF.size.width, messageFrame.contentF.size.height);
    if (self.messageFrame.message.whoSend != JK_Visitor) {
        self.sendStatusView.hidden = YES;
    }else{
        self.sendStatusView.hidden = NO;
    }
    self.sendStatusView.frame = CGRectMake(messageFrame.contentF.origin.x -50, self.messageFrame.contentF.origin.y, 44, 44);
    self.sendStatusView.msgSendStatus = messageFrame.msgSendStatus;
    if (([message.content containsString:@"http:"] ||[message.content containsString:@"https:"])&& (!message.imageWidth)) {
        
        [self downloadImageWithModelFrame:messageFrame button:self.btnContent];
        
    }else if(([message.content containsString:@"gif"] || [message.content containsString:@"png"]) && (![message.content containsString:@"http"])){
        
        self.btnContent.backImageView.yy_imageURL = [NSURL fileURLWithPath:message.content];
    }else {
        [self.btnContent.backImageView yy_setImageWithURL:[NSURL URLWithString:message.content] options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation];
    }
    
    UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnContentClick)];
    [self.btnContent.backImageView addGestureRecognizer:tapRecognize];
    
    //背景气泡图
    if (message.whoSend == JK_Visitor) {
        self.btnContent.backgroundColor = UIColorFromRGB(0xEC5642);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.btnContent.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.btnContent.bounds;
        maskLayer.path = maskPath.CGPath;
        self.btnContent.layer.mask = maskLayer;
    }else{
        self.btnContent.backgroundColor = UIColorFromRGB(0xFFFFFF);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.btnContent.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.btnContent.bounds;
        maskLayer.path = maskPath.CGPath;
        self.btnContent.layer.mask = maskLayer;
    }
    self.btnContent.systemMarkLabel.hidden = YES;
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
    
    [button.backImageView yy_setImageWithURL:[NSURL URLWithString:modelFrame.message.content] placeholder:nil options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (!error)  {
            NSMutableArray *sizeArr = [UIView returnImageViewWidthAndHeightWith:[NSString stringWithFormat:@"%lf",ceil(image.size.width)] AndHeight:[NSString stringWithFormat:@"%lf",ceil(image.size.height)]];
            
            modelFrame.message.imageWidth  = [[sizeArr objectAtIndex:0] floatValue];
            modelFrame.message.imageHeight = [[sizeArr objectAtIndex:1] floatValue];
        
            button.backImageView.image = image;
            
            if (modelFrame.message.whoSend == JK_Visitor) {
                CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
                modelFrame.contentF = CGRectMake(screenW - 16 - [[sizeArr objectAtIndex:0] floatValue], modelFrame.contentF.origin.y, [[sizeArr objectAtIndex:0] floatValue], [[sizeArr objectAtIndex:1] floatValue]);
                
                modelFrame.cellHeight = MAX(CGRectGetMaxY(modelFrame.contentF), CGRectGetMaxY(modelFrame.nameF))  + JKChatMargin;
            }else {
                modelFrame.contentF = CGRectMake(modelFrame.contentF.origin.x, modelFrame.contentF.origin.y, [[sizeArr objectAtIndex:0] floatValue], [[sizeArr objectAtIndex:1] floatValue]);
                
                modelFrame.cellHeight = MAX(CGRectGetMaxY(modelFrame.contentF), CGRectGetMaxY(modelFrame.nameF))  + JKChatMargin;
            }
            if (self.delegate &&[self.delegate respondsToSelector:@selector(cellCompleteLoadImgeUrl:)]) {
                NSString * imgUrl = [[NSString alloc] initWithString:modelFrame.message.content];
                [self.delegate cellCompleteLoadImgeUrl:imgUrl];
            }
//            if ([self.delegate respondsToSelector:@selector(cellCompleteLoadImage:)])  {
//
//                [self.delegate cellCompleteLoadImage:self];
//            }
        }
    }];
//    NSLog(@"-------22222-%lf",modelFrame.contentF.size.height);
}
-(JKMsgSendStatusView *)sendStatusView{
    __weak typeof(self) weakSelf = self;
    if (_sendStatusView == nil) {
        _sendStatusView = [[JKMsgSendStatusView alloc]initWithFrame:CGRectZero];
        _sendStatusView.reSendMsgBlock = ^{
            NSLog(@"%@",weakSelf.messageFrame.message.content);
            if (weakSelf.delegate && [self.delegate respondsToSelector:@selector(reSendImageWithImageData:image:)]) {
                [weakSelf.delegate reSendImageWithImageData:weakSelf.messageFrame.message.imageData image:weakSelf.btnContent.backImageView.image];
            }
//            if (weakSelf.sendMsgBlock) {
//                weakSelf.sendMsgBlock(weakSelf.messageFrame.message.content);
//            }
        };
    }
    return _sendStatusView;
}
@end
