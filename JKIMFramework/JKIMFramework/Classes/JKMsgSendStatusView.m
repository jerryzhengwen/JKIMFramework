//
//  JKMsgSendStatusView.m
//  JKIMSDKProject
//
//  Created by 陈天栋 on 2021/10/12.
//  Copyright © 2021 于飞. All rights reserved.
//

#import "JKMsgSendStatusView.h"


@interface JKMsgSendStatusView ()

/**
 发送中圆圈提示
 */
 @property (nonatomic ,strong)UIActivityIndicatorView * sendingImg;
 //@property (nonatomic ,strong)UIView * sendingImg;
 /*
 重新发送按钮
 */
@property (nonatomic ,strong)UIButton * reSendBtn;

@end

@implementation JKMsgSendStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubView];
    }
    return self;
}
-(void)createSubView{
    self.reSendBtn.frame = CGRectMake(10, 5, 30, 30);
    self.sendingImg.frame = CGRectMake(0, 0, 44, 44);
    [self addSubview:self.reSendBtn];
    [self addSubview:self.sendingImg];
}
-(void)setMsgSendStatus:(JKMsgSendStatus)msgSendStatus{
    _msgSendStatus = msgSendStatus;
    switch (msgSendStatus) {
        case JK_MsgSendFail:
            self.reSendBtn.hidden = NO;
            [self.sendingImg stopAnimating];
            self.sendingImg.hidden = YES;
            break;
        case JK_MsgSendSuccess:
            self.reSendBtn.hidden = YES;
            [self.sendingImg stopAnimating];
            self.sendingImg.hidden = YES;
            break;
        case JK_MsgSending:
            self.reSendBtn.hidden = YES;
            [self.sendingImg startAnimating];
            self.sendingImg.hidden = NO;
            break;
    }
}
//-(void)layoutSubviews{
//    [super layoutSubviews];
//    self.reSendBtn.frame = self.frame;
//    self.sendingImg.frame = self.frame;
//}
-(UIButton *)reSendBtn{
    if (_reSendBtn == nil) {
        _reSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *sendErrImage = [[JKBundleTool initBundlePathWithImage] stringByAppendingPathComponent:@"icon_sendError"];
        [_reSendBtn setBackgroundImage:[UIImage imageWithContentsOfFile:sendErrImage] forState:UIControlStateNormal];
        [_reSendBtn addTarget:self action:@selector(reSendMsg) forControlEvents:UIControlEventTouchUpInside];
//        _reSendBtn.hidden = YES;
    }
    return _reSendBtn;
}
-(UIActivityIndicatorView *)sendingImg{
    if (_sendingImg == nil) {
        _sendingImg = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _sendingImg;
}
-(void)reSendMsg{
    NSLog(@"重发消息");
    if (self.reSendMsgBlock) {
        self.reSendMsgBlock();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
