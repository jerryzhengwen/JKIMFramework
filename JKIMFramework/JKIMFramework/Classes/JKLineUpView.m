//
//  JKLineUpView.m
//  JKIMSDKProject
//
//  Created by Jerry on 2019/11/4.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKLineUpView.h"
#import "JKDialogueHeader.h"
@interface JKLineUpView()
@property (nonatomic,strong)UIView *whiteView;
@property (nonatomic,strong)UILabel *tipLabel;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UILabel *numberLabel;
@end

@implementation JKLineUpView
-(instancetype)init {
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 12.0f;
        self.backgroundColor = JKBGDefaultColor;
        self.clipsToBounds = YES;
        [self createSubViews];
    }
    return self;
}
-(void)createSubViews {
    self.whiteView = [self createBackView];
    self.whiteView.layer.cornerRadius = 12;
    self.whiteView.clipsToBounds = YES;
    
    self.whiteView.layer.shadowColor = UIColorFromRGB(0x000000).CGColor;
    // 阴影偏移，默认(0, -3)
    self.whiteView.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    self.whiteView.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    self.whiteView.layer.shadowRadius = 5;
    
    [self addSubview:self.whiteView];
    self.tipLabel = [self createRegularLabelWithTitle:@"当前排队人数较多，请您耐心等待" size:15];
    [self.whiteView addSubview:self.tipLabel];
    
    self.lineView = [self createBackView];
    self.lineView.backgroundColor = UIColorFromRGB(0xE5E5E5);
    [self.whiteView addSubview:self.lineView];
    
    self.numberLabel = [[UILabel alloc] init];
    [self.whiteView addSubview:self.numberLabel];
    
    self.numberLabel.textAlignment = NSTextAlignmentRight;
}
-(void)setIndex:(NSNumber *)index {
    _index = index;
    NSString * content = [[NSString alloc] initWithFormat:@"%@",index];
    UIFont * font;
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 9.0) {
        font =  [UIFont boldSystemFontOfSize:24];
    }else {
        font = [UIFont fontWithName:@"PingFangSC-Semibold" size:24];
    }
    UIFont *rightFont = [self getFontWithSize:15];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 位",index]];
    
    [string addAttributes:@{NSFontAttributeName: font} range:NSMakeRange(0, content.length)];
    [string addAttributes:@{NSFontAttributeName: rightFont} range:NSMakeRange(string.length - 1, 1)];
    [string addAttributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xEC5642)} range:NSMakeRange(0, content.length)];
    [string addAttributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0x3E3E3E)} range:NSMakeRange(string.length -1,1)];
    self.numberLabel.attributedText = string;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.whiteView.frame = CGRectMake(16, 16, self.width - 32, 44);
    self.tipLabel.frame = CGRectMake(12, 12, 225, 20);
    CGFloat margin = 10;
    if (self.whiteView.width - 225 - 12 >= 106) {
        margin = 25;
    }
    self.lineView.frame = CGRectMake(CGRectGetMaxX(self.tipLabel.frame) + margin, 12, 1, 20);
    CGFloat minx = CGRectGetMaxX(self.lineView.frame);
    self.numberLabel.frame = CGRectMake(minx, 12, self.whiteView.width - 12 -minx , 20);
}
@end
