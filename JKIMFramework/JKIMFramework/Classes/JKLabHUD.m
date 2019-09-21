//
//  JKLabHUD.m
//  JKIMSDKProject
//
//  Created by Jerry on 2019/9/21.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKLabHUD.h"

@interface JKLabHUD ()
@property (nonatomic,strong) UILabel *msgLab;

@end


@implementation JKLabHUD

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (instancetype)shareHUD {
    static JKLabHUD *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


- (void)showMessageOnTop:(NSString *)messag  View:(UIView*)oView{
    
    UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, messag.length * 18, 36)];
    messageLabel.backgroundColor = [UIColor colorWithRed:0/ 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.8];
    messageLabel.text = messag;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.layer.cornerRadius = 5;
    messageLabel.layer.masksToBounds = YES;
    messageLabel.font = [UIFont systemFontOfSize:15];
    [oView addSubview:messageLabel];
    
    
    [UIView animateWithDuration:2 animations:^{
        messageLabel.alpha = 0;
    }completion:^(BOOL finished) {
        [messageLabel removeFromSuperview];
    }];
}

- (void)showWithMsg:(NSString *)msg {
    if (self.msgLab == nil) {
        self.msgLab = [[UILabel alloc] init];
        self.msgLab.textColor = [UIColor whiteColor];
        self.msgLab.backgroundColor = [UIColor clearColor];
        self.msgLab.numberOfLines = 0;
        self.msgLab.font = [UIFont systemFontOfSize:18];
        self.msgLab.textAlignment = NSTextAlignmentCenter;
        self.msgLab.lineBreakMode = NSLineBreakByCharWrapping;
        
        self.layer.cornerRadius = 4.0;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        [self addSubview:self.msgLab];
        self.msgLab.text = msg;
        [self.msgLab sizeToFit];
        CGRect labRect = self.msgLab.frame;
        CGFloat lab_W = 0;
        if (labRect.size.width > ([UIScreen mainScreen].bounds.size.width/2)) {
            lab_W = [UIScreen mainScreen].bounds.size.width/2+15;
            labRect.size.width = lab_W;
            self.msgLab.frame = labRect;
            [self.msgLab sizeToFit];
        }else{
            lab_W = labRect.size.width;
        }
        
        self.msgLab.frame = CGRectMake(15, 15, lab_W, self.msgLab.frame.size.height);
        //        [self mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        }];
        CGFloat allHeight =  [[UIScreen mainScreen] bounds].size.height;
        CGFloat selfHight = self.msgLab.frame.size.height +30;
        CGFloat selfWidth =self.msgLab.frame.size.width + 30;
        CGFloat allWidth = [[UIScreen mainScreen] bounds].size.width;
        
        self.frame = CGRectMake((allWidth -selfWidth)/2, allHeight -selfHight - 20, selfWidth, selfHight);
        self.center = [UIApplication sharedApplication].keyWindow.center;
        
        /*
         [backView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.width.equalTo(@(lab_W+30));
         make.height.equalTo(@(self.msgLab.zd_height+30));
         make.centerY.equalTo([[UIApplication sharedApplication] keyWindow]);
         make.centerX.equalTo([[UIApplication sharedApplication] keyWindow]);
         }];
         [self.msgLab mas_makeConstraints:^(MASConstraintMaker *make) {
         make.width.equalTo(@(lab_W));
         make.height.equalTo(@(self.msgLab.zd_height));
         make.centerY.equalTo(backView);
         make.centerX.equalTo(backView);
         }];
         */
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.msgLab removeFromSuperview];
            self.msgLab = nil;
            [self removeFromSuperview];
        });
    }
}
@end
