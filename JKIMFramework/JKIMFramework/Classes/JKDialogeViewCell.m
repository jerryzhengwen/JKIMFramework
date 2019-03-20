//
//  JKDialogeViewCell.m
//  JKIMSDKProject
//
//  Created by Jerry on 2019/3/13.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKDialogeViewCell.h"
#import "JKDialogueSetting.h"
#import "UIView+JKFloatFrame.h"
#import "JKRichTextStatue.h"
#import "JKBundleTool.h"


@interface JKDialogeViewCell ()<UITextViewDelegate>
///时间Label
@property (nonatomic,strong) UILabel *timeLabel;
///显示内容的Label
@property (nonatomic,strong) UITextView *contentTV;
///头像的imageView
@property (nonatomic,strong) UIImageView * iconImageView;
@end

@implementation JKDialogeViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initOtherView];
    }
    return self;
}
/**
 初始化相关控件
 */
-(void)initOtherView {
    [self.contentView addSubview:self.timeLabel];
    self.contentTV.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:self.contentTV];
    [self.contentView addSubview:self.iconImageView];
}
-(UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
        _timeLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _timeLabel;
}
-(UITextView *)contentTV{
    if (_contentTV == nil) {
        _contentTV = [[UITextView alloc] init];
        _contentTV.editable = NO;
        _contentTV.scrollEnabled = NO;
        _contentTV.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5 );
        _contentTV.delegate = self;
        _contentTV.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
        _contentTV.layer.cornerRadius = 10.0;
        _contentTV.clipsToBounds = YES;
    }
    return _contentTV;
}
-(UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}
-(void)setModel:(JKDialogModel *)model {
    _model = model;
    JKDialogueSetting * setting = [JKDialogueSetting sharedSetting];
    switch (model.whoSend) {
        case JK_Customer:
            if (setting.customerImage) {
                self.iconImageView.image = setting.customerImage;
            }else {
                
                NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
                NSString *filePatch = [bundlePatch stringByAppendingPathComponent:@"dialogue_list_service"];
                self.iconImageView.image = [UIImage imageWithContentsOfFile:filePatch];
            }
            break;
        case JK_Visitor:
            if (setting.visitorImage) {
                self.iconImageView.image = setting.visitorImage;
            }else {
                NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
                NSString *filePatch = [bundlePatch stringByAppendingPathComponent:@"dialogue_list_visitor"];
                self.iconImageView.image = [UIImage imageWithContentsOfFile:filePatch];
            }
            break;
        case JK_Roboter:
            
            break;
        case JK_Other:
            
            break;
    }
    if (model.isRichText) {
        NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:model.message];
        if (model.customerNumber) {
            NSArray *customer = [model.message componentsSeparatedByString:@"\n"];
            NSMutableArray * removeArray = [NSMutableArray arrayWithArray:customer];
            [removeArray removeObject:@""];
            for (int i = 0; i < removeArray.count; i ++) {
                NSString *clickString = removeArray[i];
                NSRange range = [model.message rangeOfString:clickString];
                [contentStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
                [contentStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%@://",clickString] range:range];
            }
        }else {
        NSString *clickString = @"这里";
        NSRange range = [model.message rangeOfString:clickString];
        [contentStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
        [contentStr addAttribute:NSLinkAttributeName value:@"这里://" range:range];
        }
        [contentStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0, contentStr.length)];
        self.contentTV.attributedText = contentStr;
    }else {
        
        self.contentTV.text = model.message;
        JKRichTextStatue * richText = [[JKRichTextStatue alloc] init];
        richText.text = model.message;
        self.contentTV.attributedText = richText.attributedText;
        
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.time];
    
   
    [self layoutSubV];
}






-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction  API_AVAILABLE(ios(10.0)){
    if ([textView.text containsString:@"这里"] && self.model.isRichText) {
        if (self.richText) {
            self.richText();
        }
    }else if (self.model.isRichText) {
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
-(void)layoutSubV {
//    [super layoutSubviews];
    self.timeLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 -50, 0, 100, 20);
    if (self.model.whoSend == JK_Customer) {
        self.iconImageView.frame = CGRectMake(10, self.timeLabel.bottom + 12, 52, 52);
        self.contentTV.frame = CGRectMake(self.iconImageView.right +10, self.timeLabel.bottom + 10, self.model.imageWidth, self.model.imageHeight);
    }else if(self.model.whoSend == JK_Visitor){
        [self layoutIfNeeded];
        self.iconImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 62, self.timeLabel.bottom + 12, 52, 52);
        
        self.contentTV.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - self.model.imageWidth -72, self.timeLabel.bottom + 10, self.model.imageWidth, self.model.imageHeight);
    }
}
@end
