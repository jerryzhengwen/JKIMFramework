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
#import "YYWebImage.h"
#import "JKImageAvatarBrowser.h"
#import "JKMessageOpenUrl.h"
@interface JKWebViewCell()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic,strong)UIImageView *backImageView;
@property (nonatomic, strong)WKWebView *webView;
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
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 9.0) {
        self.nameLabel.font =  [UIFont systemFontOfSize:14];
    }else {
        self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
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
    self.webView.scrollView.scrollEnabled = YES;
    self.webView.layer.masksToBounds = YES;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:self.webView];
}
-(void)setMessageFrame:(JKMessageFrame *)messageFrame {
    _messageFrame = messageFrame;
    NSString * time = [NSDate getTimeStringWithIntervalString:messageFrame.message.time];
    self.labelTime.text = time;
    NSString * name = messageFrame.message.from.length?messageFrame.message.from:@"robot";
    self.nameLabel.text = name;
    NSURL *baseurl = [NSURL URLWithString:@"file:///"];
    [self.webView loadHTMLString:[self getHtmlString:messageFrame.message.content] baseURL:baseurl];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (self.messageFrame.cellHeight) {
        static NSString * const jsGetImages = @"function getImages(){var objs =document.getElementsByTagName(\"img\");var imgScr = '';for(var i=0;i<objs.length;i++){imgScr = imgScr + objs[i].src + '+';};return imgScr;};";
        [self.webView evaluateJavaScript:jsGetImages completionHandler:^(id obj, NSError * _Nullable error) {
            NSLog(@"---%@",obj);
        }];
        [self.webView evaluateJavaScript:@"getImages()"completionHandler:^(id obj, NSError * _Nullable error) {
            if ([obj isKindOfClass:[NSString class]]) {
                NSString *url = (NSString *)obj;
                if ([url containsString:@"+"]) {
                    NSString *imgUrl = [url substringToIndex:url.length -1];
                    UIImageView * img = [[UIImageView alloc] init];
                    img.yy_imageURL = [NSURL URLWithString:imgUrl];
                }
            }
        }];
        static NSString * const jsClickImage = @"function registerImageClickAction(){var imgs=document.getElementsByTagName('img');var length=imgs.length;for(var i=0;i<length;i++){img=imgs[i];img.onclick=function(){window.location.href='image-preview:'+this.src}}}";
        [self.webView evaluateJavaScript:jsClickImage completionHandler:^(id obj, NSError * _Nullable error) {
            NSLog(@"---%@",obj);
        }];
        [self.webView evaluateJavaScript:@"registerImageClickAction()"completionHandler:^(id obj, NSError * _Nullable error) {
            NSLog(@"---%@",obj);
        }];
        return;
    }
    __weak typeof(self) selfWeak = self;
    [webView evaluateJavaScript:@"document.body.offsetHeight;" completionHandler:^(id _Nullable any, NSError * _Nullable error) {
        NSString *s = [NSString stringWithFormat:@"%@",any];
        CGFloat height = [s floatValue];
        selfWeak.webView.frame = CGRectMake(0, 0, self.contentView.frame.size.width - 170, height);
        selfWeak.messageFrame.cellHeight = height;
        if (selfWeak.webHeightBlock) {
            selfWeak.webHeightBlock(self.reloadRow,self.messageFrame.moveToLast);
        }
    }];
    
    
    //    //调用自定义js
    //    [webView evaluateJavaScript:jsGetImages completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    //        NSLog(@"%@",result);
    //    }];
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
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //捕获跳转链接
    NSURL *URL = navigationAction.request.URL;
    NSString *str = [NSString stringWithFormat:@"%@",URL];
    UIImageView *imageView = [UIImageView new];
    if ([str containsString:@"image-preview:"]) {
        //查看大图
        decisionHandler(WKNavigationActionPolicyCancel); // 必须实现 不加载
        NSString *url = [[str componentsSeparatedByString:@"image-preview:"] componentsJoinedByString:@""];
        imageView.center = self.center;
        [imageView yy_setImageWithURL:[NSURL URLWithString:url] placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            if (!error && image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [JKImageAvatarBrowser showImage:imageView];
                });
            }
        }];
    }else {
        if (![str containsString:@"file:///"]) {
         [[JKMessageOpenUrl sharedOpenUrl] JK_ClickHyperMediaMessageOpenUrl:str];
        }
        decisionHandler(WKNavigationActionPolicyAllow);  // 必须实现 加载
    }
}
@end
