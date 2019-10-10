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
#import "MMImageBrower.h"
@interface JKWebViewCell()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic,strong)UIImageView *backImageView;
@property (nonatomic, strong)WKWebView *webView;
@property (nonatomic,strong) UILabel *labelTime;
@property (nonatomic,strong) UILabel *nameLabel;
@end

@implementation JKWebViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = JKBGDefaultColor;
    if (self) {
        [self createSubViews];
        NSMutableDictionary *header = [YYWebImageManager sharedManager].headers.mutableCopy;
        header[@"User-Agent"] = @"iPhone"; // for example
        [YYWebImageManager sharedManager].headers = header;
    }
    return self;
}
-(UIImageView *)backImageView {
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc] init];
        NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
        NSString *filePatch = [bundlePatch stringByAppendingPathComponent:@"chatfrom_bg_normal"];
        UIImage *normal = [UIImage imageWithContentsOfFile:filePatch];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(16, 13, 16, 21)];
//        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 20, 10, 10)];
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
    self.webView.backgroundColor = UIColorFromRGB(0xF0F0F0);
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.scrollView.scrollEnabled = YES;
    self.webView.layer.masksToBounds = YES;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:self.webView];
    
    
    for (UIView *subView in [self.webView subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]])
        {
            // 隐藏竖直的滚动条
            [(UIScrollView *)subView setShowsVerticalScrollIndicator:NO];
            UIScrollView *scrollView =    (UIScrollView *)subView;
             scrollView.bounces=NO;
            //隐藏水平的滚动条
//            [(UIScrollView *)subView setShowsHorizontalScrollIndicator:NO];
        }
                self.webView.scrollView.bounces=NO;
    }
//    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize"
//                           options:NSKeyValueObservingOptionNew context:nil];
}
#pragma mark  - KVO回调
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//
//    //更具内容的高重置webView视图的高度
////    NSLog(@"Height is changed! new=%@", [change valueForKey:NSKeyValueChangeNewKey]);
////    NSLog(@"tianxia :%@",NSStringFromCGSize(self.webView.contentSize));
//    CGFloat newHeight  = self.webView.scrollView.contentSize.height;
////    CGFloat newHeight = self.webView.contentSize.height;
//    NSLog(@"----终极kvoheight----%lf",newHeight);
//
//}
-(void)setMessageFrame:(JKMessageFrame *)messageFrame {
    _messageFrame = messageFrame;
    NSString * time = [NSDate getTimeStringWithIntervalString:messageFrame.message.time];
    self.labelTime.text = time;
//    NSString * name = messageFrame.message.from.length?messageFrame.message.from:@"robot";
//    name = @"小广";
    if (messageFrame.hiddenTime) {
        self.labelTime.text = @"";
    }
    self.nameLabel.text = @"智能客服-小广";
    NSURL *baseurl = [NSURL URLWithString:@"file:///"];
    [self.webView loadHTMLString:[self getHtmlString:messageFrame.message.content] baseURL:baseurl];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (self.messageFrame.cellHeight) {
        NSLog(@"--cellHeight--%lf",self.messageFrame.cellHeight);
        static NSString * const jsGetImages = @"function getImages(){var objs =document.getElementsByTagName(\"img\");var imgScr = '';for(var i=0;i<objs.length;i++){imgScr = imgScr + objs[i].src + '+';};return imgScr;};";
        [self.webView evaluateJavaScript:jsGetImages completionHandler:^(id obj, NSError * _Nullable error) {
            
        }];
        [self.webView evaluateJavaScript:@"getImages()"completionHandler:^(id obj, NSError * _Nullable error) {
            if ([obj isKindOfClass:[NSString class]]) {
                NSString *url = (NSString *)obj;
                if ([url containsString:@"+"]) {
//                    NSString *imgUrl = [url substringToIndex:url.length -1];
//                    UIImageView * img = [[UIImageView alloc] init];
//                    img.yy_imageURL = [NSURL URLWithString:imgUrl];
                }
            }
        }];
        static NSString * const jsClickImage = @"function registerImageClickAction(){var imgs=document.getElementsByTagName('img');var length=imgs.length;for(var i=0;i<length;i++){img=imgs[i];img.onclick=function(){window.location.href='image-preview:'+this.src}}}";
        [self.webView evaluateJavaScript:jsClickImage completionHandler:^(id obj, NSError * _Nullable error) {
            
        }];
        [self.webView evaluateJavaScript:@"registerImageClickAction()"completionHandler:^(id obj, NSError * _Nullable error) {
            
        }];
        return;
    }
    
    __weak typeof(self) selfWeak = self;
    [self.webView evaluateJavaScript:@"document.body.offsetHeight;" completionHandler:^(id _Nullable any, NSError * _Nullable error) {
        NSString *s = [NSString stringWithFormat:@"%@",any];
        CGFloat height = [s floatValue];
        selfWeak.webView.frame = CGRectMake(0, 0, self.contentView.frame.size.width - 170, height);
        NSLog(@"--height--%lf---%@",height,self.messageFrame.message.content);
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
    self.nameLabel.frame= CGRectMake(16, contentY + timeY, screenW - 100, 20);
    
    
    self.webView.frame = CGRectMake(16 + 12, CGRectGetMaxY(self.nameLabel.frame) + 16, self.contentView.frame.size.width - 170,self.messageFrame.cellHeight);
    self.backImageView.frame = CGRectMake(16, CGRectGetMinY(self.webView.frame) -12, CGRectGetWidth(self.webView.frame) + 22, CGRectGetHeight(self.webView.frame) +24);
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
    NSString *headerString = @"<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>";
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html style=\"background:#F3F3F3;overflow-y:hidden;overflow-x:auto;\">"];
    
    [html appendString:@"<head>"];
    [html appendString:headerString];
    [html appendString:@"<meta charset=\"utf-8\">"];
    NSString * path = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
    NSString * style = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    [html appendString:[NSString stringWithFormat:@"<style>%@</style>",style]];
    [html appendString:@"</head>"];
    [html appendString:@"<body>"];
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
        imageView.hidden = YES;
//        imageView.center = self.center;
        [self addSubview:imageView];
        [imageView yy_setImageWithURL:[NSURL URLWithString:url] placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//            if (!error && image) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [JKImageAvatarBrowser showImage:imageView];
//                });
//            }
            if (!error && image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //            [JKImageAvatarBrowser showImage:imageView];
                    MMImageBrower *img  =  [[MMImageBrower alloc] init];
                    img.images = @[image];
                    [img show];
                });
            }
        }];
    }else {
        if (![str containsString:@"file:///"]) {
            @try {
            [[JKMessageOpenUrl sharedOpenUrl] JK_ClickHyperMediaMessageOpenUrl:str];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
         
        }
        decisionHandler(WKNavigationActionPolicyAllow);  // 必须实现 加载
    }
}
@end
