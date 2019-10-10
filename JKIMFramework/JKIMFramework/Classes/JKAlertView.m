//
//  JKAlertView.m
//  JKIMSDKProject
//
//  Created by Jerry on 2019/10/9.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKAlertView.h"
#import "JKDialogueHeader.h"
@interface JKAlertView ()
@property (nonatomic ,strong) UIView *whiteView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;
@end

@implementation JKAlertView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self createOtherView];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSelf)];
        self.gestureRecognizers =@[gesture];
    }
    return self;
}
-(void)clickSelf{
    if (self.needUpdate.length) {
        return;
    }
    [self removeFromSuperview];
}
-(void)createOtherView {
    self.whiteView = [[UIView alloc] init];
    self.whiteView.backgroundColor = [UIColor whiteColor];
    self.whiteView.layer.cornerRadius = 12;
    self.whiteView.clipsToBounds = YES;
    self.whiteView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopGesture)];
    self.whiteView.gestureRecognizers = @[gesture];
    self.whiteView.frame = CGRectMake(0, 0, 270, 180);
    self.whiteView.center = self.center;
    [self addSubview:self.whiteView];
//    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@270);
//        make.centerX.centerY.equalTo(self);
//        make.height.equalTo(@125);
//    }];
    self.titleLabel =  [[UILabel alloc] init];
    @try {
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    } @catch (NSException *exception) {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    } @finally {
        self.titleLabel.text = @"温馨提示";
        self.titleLabel.textColor = UIColorFromRGB(0x3E3E3E);
    }
    self.titleLabel.frame = CGRectMake(16, 16,CGRectGetWidth(self.whiteView.frame) - 32 , 22);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.whiteView addSubview:self.titleLabel];
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@20);
//        make.width.centerX.equalTo(self.whiteView);
//        make.height.equalTo(@16);
//    }];
    
    self.contentLabel  = [[UILabel alloc] init];
    self.contentLabel.frame = CGRectMake(16, 54, CGRectGetWidth(self.titleLabel.frame), 22);
    self.contentLabel.text = @"您确定要结束对话吗？";
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 9.0) {
        self.contentLabel.font =  [UIFont systemFontOfSize:15];
    }else {
        self.contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    }
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.textColor = UIColorFromRGB(0x3E3E3E);
    [self.whiteView addSubview:self.contentLabel];
//    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.titleLabel.bottom).offset(13);
//        make.left.equalTo(self.whiteView).offset(5);
//        make.right.equalTo(self.whiteView).offset(-5);
//        make.centerX.equalTo(self.whiteView);
//        make.height.equalTo(@14);
//    }];
    int i = 0;
    while (i <2) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(0xE5E5E5);
        [self.whiteView addSubview:lineView];
        if (i == 0) {
        }else {
        }
//        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            if (i == 0) {
//                make.left.width.right.equalTo(self.whiteView);
//                make.bottom.equalTo(self.whiteView).offset(-43);
//                make.height.equalTo(@0.5);
//            }else {
//                make.height.equalTo(@43);
//                make.centerX.bottom.equalTo(self.whiteView);
//                make.width.equalTo(@0.5);
//            }
//        }];
        NSString * titleName = i == 0?@"取消":@"确定";
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titleName forState:UIControlStateNormal];
        [self.whiteView addSubview:button];
        if (i == 0) {
            lineView.frame = CGRectMake(0, 136, CGRectGetWidth(self.whiteView.frame), 0.5);
            self.leftButton = button;
            [button setTitleColor:UIColorFromRGB(0x9B9B9B) forState:UIControlStateNormal];
            if ([[UIDevice currentDevice].systemVersion doubleValue] < 9.0) {
                button.titleLabel.font =  [UIFont systemFontOfSize:17];
            }else {
                button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
            }
        }else {
            lineView.frame = CGRectMake(136, 134.5, 0.5, 44);
            [button setTitleColor:UIColorFromRGB(0xEC5642) forState:UIControlStateNormal];
            self.rightButton = button;
            @try {
                button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
            } @catch (NSException *exception) {
                button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
            } @finally {
                
            }
            
        }
        int width = 135;
        button.frame = CGRectMake(i * width, CGRectGetHeight(self.whiteView.frame) - 44, 135, 44);
//        [button mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(@135);
//            make.left.equalTo(self.whiteView).offset(i * width);
//            make.bottom.equalTo(self.whiteView);
//            make.height.equalTo(@43);
//        }];
        [button addTarget:self action:@selector(chooseClick:) forControlEvents:UIControlEventTouchUpInside];
        i ++;
    }
}
-(void)chooseClick:(UIButton *)button {
    [self clickSelf];
    BOOL clickCancel = NO;
    if ([button isEqual:self.leftButton]) {
        clickCancel = YES;
    }
    if (self.clickBlock) {
        self.clickBlock(clickCancel);
    }
}
-(void)stopGesture {}
-(void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}
-(void)setContent:(NSString *)content {
    self.contentLabel.text = content;
}
-(void)setLeftTitle:(NSString *)leftTitle {
    [self.leftButton setTitle:leftTitle forState:UIControlStateNormal];
}
-(void)setRightTitle:(NSString *)rightTitle {
    [self.rightButton setTitle:rightTitle forState:UIControlStateNormal];
}
-(void)setNeedUpdate:(NSString *)needUpdate {
    _needUpdate = needUpdate;
    [self.rightButton setTitle:@"前去更新" forState:UIControlStateNormal];
//    self.leftButton.hidden = YES;
//    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.bottom.left.equalTo(self.whiteView);
//        make.height.equalTo(@43);
//    }];
    [self bringSubviewToFront:self.leftButton];
}

@end
