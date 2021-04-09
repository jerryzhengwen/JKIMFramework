//
//  JKLineUpCell.m
//  JKIMSDKProject
//
//  Created by Jerry on 2019/11/4.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKLineUpCell.h"
#import "JKLabHUD.h"
#import "JKDialogueHeader.h"
@interface JKLineUpCell()<UITextViewDelegate>
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UIButton *lineUpBtn;
@end

@implementation JKLineUpCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = JKBGDefaultColor;
        [self createSubViews];
    }
    return self;
}
-(void)createSubViews {
    self.backView = [self createBackView];
    self.backView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.backView];
    
    self.lineUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, MaxContentWidth + 30, 34);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.3),@(1.0)];//渐变点
    [gradientLayer setColors:@[(id)UIColorFromRGB(0xFF8E48).CGColor,(id)UIColorFromRGB(0xFF6262).CGColor]];//渐变数组
        [self.lineUpBtn.layer addSublayer:gradientLayer];

    [self.lineUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.lineUpBtn setTitle:@"转人工" forState:UIControlStateNormal];
    self.lineUpBtn.titleLabel.font = JKChatContentFont;
    
    self.lineUpBtn.layer.cornerRadius = 17.0f;
    self.lineUpBtn.clipsToBounds = YES;
    [self.lineUpBtn addTarget:self action:@selector(lineUpCustomer:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:self.lineUpBtn];
    
    self.textView = [self createRegularTextViewWithTitle:@"" size:15];
    self.textView.font = JKChatContentFont;
    self.textView.delegate = self;
    self.textView.textColor = UIColorFromRGB(0x3E3E3E);
    self.textView.showsVerticalScrollIndicator = NO;
    self.textView.scrollEnabled = NO;
    [self.backView addSubview:self.textView];
    [self.contentView addSubview:self.solveBtn];
    [self.contentView addSubview:self.unSloveBtn];
}
-(void)clickSolveBtn:(UIButton *)button {
    if (self.dissMissKeyBoardBlock) {
        self.dissMissKeyBoardBlock();
    }
    if (self.model.isBeforeDialog) {
        [[JKLabHUD shareHUD] showWithMsg:@"已结束对话不能点评"];
        return;
    }
    if (self.solveBtn.selected || self.unSloveBtn.selected) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[JKLabHUD shareHUD] showWithMsg:@"您已经点评过了请勿重复点评"];
        });
        return;
    }
    [button setTitleColor:UIColorFromRGB(0xEC5642) forState:UIControlStateNormal];
    button.selected = !button.selected;
    if ([self.solveBtn isEqual:button]) {
        self.model.message.isClickSolveBtn = YES;
    }else {
        self.model.message.isClickUnSolveBtn = YES;
    }
    NSString * imgStr = [self.solveBtn isEqual:button]?@"jkim_praise_press":@"jkim_trample_press";
    NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
    NSString *filePatch = [bundlePatch stringByAppendingPathComponent:imgStr];
    UIImage *image = [UIImage imageWithContentsOfFile:filePatch];
    [button setImage:image forState:UIControlStateNormal];
    if (self.clickBtnBlock) {
        self.clickBtnBlock([self.solveBtn isEqual:button],self.model.message.content,self.model.message.messageId,[[JKConnectCenter sharedJKConnectCenter] JKIM_getContext_id]);
    }
}
-(UIButton *)solveBtn {
    if (_solveBtn == nil) {
        _solveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_solveBtn setTitle:@"解决" forState:UIControlStateNormal];
        [_solveBtn addTarget:self action:@selector(clickSolveBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_solveBtn setTitleColor:UIColorFromRGB(0x9B9B9B) forState:UIControlStateNormal];
        _solveBtn.backgroundColor = UIColor.whiteColor;
        _solveBtn.layer.cornerRadius = 8;
        _solveBtn.clipsToBounds = YES;
        _solveBtn.hidden = YES;
        _solveBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    }
    return _solveBtn;
}
-(UIButton *)unSloveBtn {
    if (_unSloveBtn == nil) {
        _unSloveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unSloveBtn setTitle:@"未解决" forState:UIControlStateNormal];
        [_unSloveBtn addTarget:self action:@selector(clickSolveBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_unSloveBtn setTitleColor:UIColorFromRGB(0x9B9B9B) forState:UIControlStateNormal];
        _unSloveBtn.backgroundColor = UIColor.whiteColor;
        _unSloveBtn.layer.cornerRadius = 8;
        _unSloveBtn.clipsToBounds = YES;
        _unSloveBtn.hidden = YES;
        _unSloveBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    }
    return _unSloveBtn;
}
-(void)setModel:(JKMessageFrame *)model {
    _model = model;
    NSString *contentTxt = model.message.content;
    JKRichTextStatue * richText = [[JKRichTextStatue alloc] init];
    if ([contentTxt containsString:@"class='instructClass' target='_blank'"]||[contentTxt containsString:@"class='nc-send-msg'"]|| [contentTxt containsString:@"class=\"instructClass\" target=\"_blank\""] || [contentTxt containsString:@"class=\"nc-send-msg\""]) {
        NSString *text = [self returnSpanContent:contentTxt AndZhengZe:@"<a[^>]*>([^<]+)</a>"];
        NSString *content = [[contentTxt componentsSeparatedByString:text] componentsJoinedByString:@""];
//        richText.text = content;   修改
        
        
        NSMutableAttributedString *contentStr = [self parseHtmlStr:content];
        richText.attributedText = contentStr;
        NSString *aText = [self returnSpanContent:contentTxt AndZhengZe:@"<a[^>]*>([^<]+)"];
        NSString *aLabel = [self returnSpanContent:contentTxt AndZhengZe:@"<a[^>]*>"];
        NSString *btnTitle = [[aText componentsSeparatedByString:aLabel] componentsJoinedByString:@""];
        [self.lineUpBtn setTitle:btnTitle forState:UIControlStateNormal];
    }else {
        richText.text = contentTxt;
        [self.lineUpBtn setTitle:@"转人工" forState:UIControlStateNormal];
    }
    self.textView.linkTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGB(0xEC5642)};
    self.textView.attributedText = richText.attributedText;
    self.textView.font = JKChatContentFont;
    self.textView.textColor = UIColorFromRGB(0x3E3E3E);
    self.unSloveBtn.hidden = !model.message.isComments;
    self.solveBtn.hidden = !model.message.isComments;
    if (!self.solveBtn.hidden) {
        NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
        NSString *filePatch;
        if (model.message.isClickSolveBtn) {
            filePatch = [bundlePatch stringByAppendingPathComponent:@"jkim_praise_press"];
            self.solveBtn.selected = YES;
            [self.solveBtn setTitleColor:UIColorFromRGB(0xEC5642) forState:UIControlStateNormal];
        }else {
            [self.solveBtn setTitleColor:UIColorFromRGB(0x9B9B9B) forState:UIControlStateNormal];
            self.solveBtn.selected = NO;
            filePatch = [bundlePatch stringByAppendingPathComponent:@"jkim_praise_def"];
        }
        NSString *unSolvePath;
        if (model.message.isClickUnSolveBtn) {
            unSolvePath   = [bundlePatch stringByAppendingPathComponent:@"jkim_trample_press"];
            self.unSloveBtn.selected = YES;
            [self.unSloveBtn setTitleColor:UIColorFromRGB(0xEC5642) forState:UIControlStateNormal];
        }else {
            unSolvePath = [bundlePatch stringByAppendingPathComponent:@"jkim_trample_def"];
            self.unSloveBtn.selected = NO;
             [self.unSloveBtn setTitleColor:UIColorFromRGB(0x9B9B9B) forState:UIControlStateNormal];
        }
        UIImage *image = [UIImage imageWithContentsOfFile:filePatch];
        [self.solveBtn setImage:image forState:UIControlStateNormal];
        
        UIImage *unSolveImage = [UIImage imageWithContentsOfFile:unSolvePath];
        [self.unSloveBtn setImage:unSolveImage forState:UIControlStateNormal];
    }
}
-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat textHeight = self.model.contentF.size.height;
    CGFloat backHeight = textHeight + 102 -25;
    self.backView.frame = CGRectMake(16, 4, self.model.contentF.size.width + 24, backHeight);
    self.textView.frame = CGRectMake(12, 12, self.model.contentF.size.width, textHeight);
//    self.textView.backgroundColor = [UIColor redColor];
    self.lineUpBtn.frame = CGRectMake(12, textHeight + 15, self.model.contentF.size.width, 34);
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.backView.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.backView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.backView.layer.mask = maskLayer;
    
    self.solveBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 6, 46, 46);
    self.solveBtn.titleEdgeInsets = UIEdgeInsetsMake(28, -22, 0, 0);
    self.solveBtn.imageEdgeInsets = UIEdgeInsetsMake(6, 12, 18, 12);
    self.unSloveBtn.frame = CGRectMake(CGRectGetMinX(self.solveBtn.frame), CGRectGetMaxY(self.solveBtn.frame) + 10, 46, 46);
    self.unSloveBtn.titleEdgeInsets = UIEdgeInsetsMake(28, -22, 0, 0);
    self.unSloveBtn.imageEdgeInsets = UIEdgeInsetsMake(6, 12, 18, 12);   
}
-(void)lineUpCustomer:(UIButton *)button {
    NSString *contentTxt = self.model.message.content;
    if ([contentTxt containsString:@"class='instructClass' target='_blank'"]||[contentTxt containsString:@"class='nc-send-msg'"] || [contentTxt containsString:@"class=\"instructClass\" target=\"_blank\""] || [contentTxt containsString:@"class=\"nc-send-msg\""]) {
        if ([contentTxt containsString:@"class='instructClass' target='_blank'"]||[contentTxt containsString:@"class=\"instructClass\" target=\"_blank\""]) { //给app
            NSString *aLink = [self returnSpanContent:contentTxt AndZhengZe:[NSString stringWithFormat:@"<a[^>]*>%@</a>",self.lineUpBtn.titleLabel.text]];
            NSString * href = [self returnSpanContent:aLink AndZhengZe:@"href=['\"](.+?)['\"]"]; //href=['\"](.+?)['\"]
            NSString * url = @"";
            if ([href containsString:@"href='"]) {
                url = [href substringWithRange:NSMakeRange(6, href.length - 7)];
            }else {
                NSString * hrefUrl = [href componentsSeparatedByString:@"="].lastObject;
                href = [[hrefUrl componentsSeparatedByString:@"\""] componentsJoinedByString:@""];
                url =  [[href componentsSeparatedByString:@"'"] componentsJoinedByString:@""];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[JKMessageOpenUrl sharedOpenUrl] JK_ClickHyperMediaMessageOpenUrl:url];
            });
        }else { //发送文字
            if (self.sendMsgBlock) {
                self.sendMsgBlock(self.lineUpBtn.titleLabel.text);
            }
        }
        
        return;
    }
    if (self.model.isClickOnce) {
        return;
    }
    self.model.isClickOnce = YES;
    if (self.lineUpBlock) {
        self.lineUpBlock();
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//两次提取a标签用来提取<a> 2</a>中的值
-(NSString *)returnSpanContent:(NSString *)span AndZhengZe:(NSString *)pattern {
    if (!span) {
        return @"";
    }
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:span options:0 range:NSMakeRange(0, [span length])];
    
    
   NSArray <NSTextCheckingResult *> * test = [regex matchesInString:span options:0 range:NSMakeRange(0, [span length])];
    for (NSTextCheckingResult *obj in test) {
        NSString * str = [span substringWithRange:obj.range];
        if ([str containsString:@"class='instructClass' target='_blank'"]||[str containsString:@"class=\"instructClass\" target=\"_blank\""]||[str containsString:@"class='nc-send-msg'"]||[str containsString:@"class=\"nc-send-msg\""]) {
            return str;
        }else {
            continue;
        }
    }
    
    NSTextCheckingResult * last = test.lastObject;
    if (last) {
        return [span substringWithRange:last.range];
    }else{
        return @"";
    }
    
//    if (result) {
//        return  [span substringWithRange:result.range];
//    }else {
//        return @"";
//    }
}
- (NSMutableAttributedString *)parseHtmlStr:(NSString *)htmlStr {
    NSMutableAttributedString *attributedString;
    @try {
        //        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"</br>" withString:@"\n"];
        //        attributedString = [[NSMutableAttributedString alloc] initWithString:htmlStr];
        attributedString  = [[NSMutableAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
        //        [attributedString setAttributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone)}
        //                         range:NSMakeRange(0, attributedString.string.length)];
    } @catch (NSException *exception) {
        attributedString = [[NSMutableAttributedString alloc] initWithString:htmlStr];
    } @finally {
    }
    
    return attributedString;
}
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    __block  NSString * urlStr = URL.absoluteString;
    NSString *contentTxt = self.model.message.content;
    //此时是发送文字链接
    if ([contentTxt containsString:@"class='nc-text-link' href='javascript:void(0);'"]) {
        
        NSString *text = @"";
        text = [textView.text substringWithRange:characterRange];
        NSString *aLink = [self returnSpanContent:contentTxt AndZhengZe:[NSString stringWithFormat:@"<a[^>]*>%@</a>",text]];
        if ([aLink containsString:@"class='nc-text-link' href='javascript:void(0);'"]) {
            if (self.sendMsgBlock) {
                self.sendMsgBlock(text);
            }
            return NO;
        }
    }
    if (urlStr.length) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString * lastStr = [urlStr substringFromIndex:urlStr.length -1];
            if ([lastStr isEqualToString:@"/"]) {
                NSString * lowerString = [contentTxt lowercaseString];
                if (![lowerString containsString:urlStr]) {
                    urlStr = [urlStr substringToIndex:urlStr.length - 1];
                }
            }
            [[JKMessageOpenUrl sharedOpenUrl] JK_ClickHyperMediaMessageOpenUrl:urlStr];
        });
    }else { //获取下一级业务类型
        
    }
    return NO;
}
@end
