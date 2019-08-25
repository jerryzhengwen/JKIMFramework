//
//  JKWebViewCell.m
//  JKIMSDKProject
//
//  Created by Jerry on 2019/8/24.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKWebViewCell.h"
#import <WebKit/WebKit.h>
#import "JKDialogueHeader.h"
#import "NSDate+Utils.h"
@interface JKWebViewCell()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic,strong)UIImageView *backImageView;
@property (nonatomic, strong)  WKWebView                        *webView;
@property (nonatomic,strong) UILabel *labelTime;
@property (nonatomic,strong) UILabel *nameLabel;
@end

@implementation JKWebViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}
-(UIImageView *)backImageView {
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc] init];
        NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
        NSString *filePatch = [bundlePatch stringByAppendingPathComponent:@"chatfrom_bg_normal"];
      UIImage *normal = [UIImage imageWithContentsOfFile:filePatch];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 20, 10, 10)];
        _backImageView.image = normal;
    }
    return _backImageView;
}
-(void)createSubViews {
    [self.contentView addSubview:self.backImageView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = UIColorFromRGB(0x9B9B9B);
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [self.contentView addSubview:self.nameLabel];
    
    
    self.labelTime = [[UILabel alloc] init];
    self.labelTime.textAlignment = NSTextAlignmentCenter;
    self.labelTime.textColor = UIColorFromRGB(0x9B9B9B);
    self.labelTime.font = JKChatTimeFont;
    [self.contentView addSubview:self.labelTime];
    
    WKWebViewConfiguration *confign = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    confign.userContentController = userContentController;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width -170, 0) configuration:confign];
    self.webView.backgroundColor = [UIColor redColor];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.layer.masksToBounds = YES;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:self.webView];
}
-(void)setMessageFrame:(JKMessageFrame *)messageFrame {
    _messageFrame = messageFrame;
    self.labelTime.text = [NSDate changeTheDateString:messageFrame.message.time];
    NSString * name = messageFrame.message.from.length?messageFrame.message.from:@"robot";
    self.nameLabel.text = name;
    NSURL *baseurl = [NSURL URLWithString:@"file:///"];
    [self.webView loadHTMLString:[self getHtmlString:messageFrame.message.content] baseURL:baseurl];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (self.messageFrame.cellHeight) {
        return;
    }
    __weak typeof(self) selfWeak = self;
    [webView evaluateJavaScript:@"document.body.offsetHeight;" completionHandler:^(id _Nullable any, NSError * _Nullable error) {
        NSString *s = [NSString stringWithFormat:@"%@",any];
        CGFloat height = [s floatValue];
        selfWeak.webView.frame = CGRectMake(0, 0, self.contentView.frame.size.width - 170, height);
        selfWeak.messageFrame.cellHeight = height;
        if (selfWeak.webHeightBlock) {
            selfWeak.webHeightBlock();
        }
    }];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    // 1、计算时间的位置
    CGFloat timeY = JKChatMargin;
    self.labelTime.frame = CGRectMake(0, timeY, screenW, 17);
    CGFloat contentY = CGRectGetMaxY(self.labelTime.frame);
    self.nameLabel.frame= CGRectMake(24, contentY + 30, screenW - 100, 20);
    
    
    self.webView.frame = CGRectMake(44, CGRectGetMaxY(self.nameLabel.frame) + 13, self.contentView.frame.size.width - 170,self.messageFrame.cellHeight);
    self.backImageView.frame = CGRectMake(20, CGRectGetMinY(self.webView.frame) -9, CGRectGetWidth(self.webView.frame) + 44, CGRectGetHeight(self.webView.frame) +17);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - 拼接html 内容
- (NSString *)getHtmlString:(NSString *)htmlContent {
    NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>";
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:headerString];
    [html appendString:@"<head>"];
    [html appendString:@"<meta charset=\"utf-8\">"];
    NSString * path = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
    NSString * style = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    [html appendString:[NSString stringWithFormat:@"<style>%@</style>",style]];
    [html appendString:@"</head>"];
    [html appendString:@"<body style=\"background:#F0F0F0\">"];
    [html appendString:htmlContent];
    [html appendString:@"</body>"];
    [html appendString:@"</html>"];
    return html;
}
@end
