//
//  UUMessageContentButton.m
//  BloodSugarForDoc
//
//  Created by zzx on 2019/3/12.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKMessageContent.h"
#import "JKDialogueHeader.h"

@interface JKMessageContent()

@end

@implementation JKMessageContent

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //背景图
        self.backgroundImageView = [[UIImageView alloc]init];
        self.backgroundImageView.layer.cornerRadius = 5;
        self.backImageView.layer.masksToBounds  = YES;
        [self addSubview:self.backgroundImageView];
        
        //图片
        self.backImageView = [[UIImageView alloc]init];
        self.backImageView.userInteractionEnabled = YES;
        self.backImageView.layer.cornerRadius = 5;
        self.backImageView.layer.masksToBounds  = YES;
        self.backImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backImageView];
        
        //内容
        self.contentTV = [[UITextView alloc] init];
        self.contentTV.editable = NO;
        self.contentTV.scrollEnabled = NO;
        self.contentTV.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5 );
        self.contentTV.backgroundColor = [UIColor clearColor];
        [self addSubview:self.contentTV];
        
        //提示Label
        self.systemMarkLabel = [[JKSystemMarkLabel alloc]init];
        self.systemMarkLabel.textColor = UIColorFromRGB(0xC0C0C0);
        self.systemMarkLabel.layer.borderWidth = 1;
        self.systemMarkLabel.layer.borderColor = UIColorFromRGB(0xC0C0C0).CGColor;
        self.systemMarkLabel.layer.cornerRadius = 4;
        self.systemMarkLabel.textAlignment = NSTextAlignmentCenter;
        self.systemMarkLabel.font = [UIFont systemFontOfSize:12];
        self.systemMarkLabel.numberOfLines = 0;
        self.systemMarkLabel.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        self.systemMarkLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.systemMarkLabel];
        
        
        //语音
        self.voiceBackView = [[UIView alloc]init];
        [self addSubview:self.voiceBackView];
        self.second = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
        self.second.textAlignment = NSTextAlignmentCenter;
        self.second.font = [UIFont systemFontOfSize:14];
        self.voice = [[UIImageView alloc]initWithFrame:CGRectMake(80, 5, 20, 20)];
        self.voice.image = [UIImage imageNamed:@"chat_animation_white3"];
        self.voice.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"chat_animation_white1"],
                                      [UIImage imageNamed:@"chat_animation_white2"],
                                      [UIImage imageNamed:@"chat_animation_white3"],nil];
        self.voice.animationDuration = 1;
        self.voice.animationRepeatCount = 0;
        self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.indicator.center=CGPointMake(80, 15);
        [self.voiceBackView addSubview:self.indicator];
        [self.voiceBackView addSubview:self.voice];
        [self.voiceBackView addSubview:self.second];
        
        self.backImageView.userInteractionEnabled = NO;
        self.voiceBackView.userInteractionEnabled = NO;
        self.second.userInteractionEnabled = NO;
        self.voice.userInteractionEnabled = NO;
        self.userInteractionEnabled = YES;
        
        self.second.backgroundColor = [UIColor clearColor];
        self.voice.backgroundColor = [UIColor clearColor];
        self.voiceBackView.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
- (void)benginLoadVoice
{
    self.voice.hidden = YES;
    [self.indicator startAnimating];
}
- (void)didLoadVoice
{
    self.voice.hidden = NO;
    [self.indicator stopAnimating];
    [self.voice startAnimating];
}
-(void)stopPlay
{
//    if(self.voice.isAnimating){
        [self.voice stopAnimating];
//    }
}

- (void)setIsMyMessage:(BOOL)isMyMessage
{
    _isMyMessage = isMyMessage;
    if (isMyMessage) {
//        self.backImageView.frame = CGRectMake(5, 5, 220, 220);
        self.voiceBackView.frame = CGRectMake(15, 10, 130, 35);
        self.second.textColor = [UIColor whiteColor];
    }else{
//        self.backImageView.frame = CGRectMake(15, 5, 220, 220);
        self.voiceBackView.frame = CGRectMake(25, 10, 130, 35);
        self.second.textColor = [UIColor grayColor];
    }
}
//添加
//- (BOOL)canBecomeFirstResponder
//{
//    return YES;
//}
//-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
//    return (action == @selector(copy:));
//}
//
//-(void)copy:(id)sender{
//    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
//    pboard.string = self.contentTV.text;
//}


@end
