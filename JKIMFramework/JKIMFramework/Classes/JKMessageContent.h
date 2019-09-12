//
//  UUMessageContentButton.h
//  BloodSugarForDoc
//
//  Created by zzx on 2019/3/12.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JKSystemMarkLabel.h"

@interface JKMessageContent : UIView

//bubble imgae
@property (nonatomic, retain) UIImageView *backImageView;
//背景图
@property (nonatomic, retain) UIImageView *backgroundImageView;

///显示内容的Label
@property (nonatomic,strong) UITextView   *contentTV;

//@property (nonatomic,strong) UILabel *contentLabel;

///提示label
@property(nonatomic, strong) JKSystemMarkLabel *systemMarkLabel;

//audio
@property (nonatomic, retain) UIView *voiceBackView;
@property (nonatomic, retain) UILabel *second;
@property (nonatomic, retain) UIImageView *voice;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;

@property (nonatomic, assign) BOOL isMyMessage;


- (void)benginLoadVoice;

- (void)didLoadVoice;

-(void)stopPlay;

@end
