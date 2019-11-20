//
//  JKLineUpCell.m
//  JKIMSDKProject
//
//  Created by Jerry on 2019/11/4.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKLineUpCell.h"
#import "JKDialogueHeader.h"
@interface JKLineUpCell()
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
    gradientLayer.frame = CGRectMake(0, 0, MaxContentWidth + 20, 34);
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
    self.textView.textColor = UIColorFromRGB(0x3E3E3E);
    [self.backView addSubview:self.textView];
}
-(void)setModel:(JKMessageFrame *)model {
    _model = model;
    JKRichTextStatue * richText = [[JKRichTextStatue alloc] init];
    richText.text = model.message.content;
    self.textView.attributedText = richText.attributedText;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat textHeight = self.model.contentF.size.height;
    CGFloat backHeight = textHeight + 102;
    self.backView.frame = CGRectMake(16, 4, self.model.contentF.size.width + 24, backHeight);
    self.textView.frame = CGRectMake(12, 12, self.model.contentF.size.width, textHeight);
    self.lineUpBtn.frame = CGRectMake(12, textHeight + 40, self.model.contentF.size.width, 34);
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.backView.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.backView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.backView.layer.mask = maskLayer;
}
-(void)lineUpCustomer:(UIButton *)button {
    if (self.model.isClickLineUpBtn) {
        return;
    }
    self.model.isClickLineUpBtn = YES;
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

@end
