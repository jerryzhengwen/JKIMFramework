//
//  JKSatisfactionViewCell.m
//  JKIMSDKProject
//
//  Created by Jerry on 2019/10/9.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKSatisfactionViewCell.h"
#import "JKDialogueHeader.h"
#import "UIView+JKFloatFrame.h"
@interface JKSatisfactionViewCell()<UITextViewDelegate>
@property (nonatomic,strong)UIImageView *bgImageView;
@property (nonatomic,strong)UILabel *firstLabel;
@property (nonatomic,strong)NSMutableArray *firstBtnArr;
@property (nonatomic,strong)NSMutableArray *secondBtnArr;
@property (nonatomic,strong)UILabel *secondLabel;
@property (nonatomic,strong)UILabel *satisLabel;
@property (nonatomic,strong)UILabel *thirdLabel;
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,copy) NSString *placeHolder;
@property (nonatomic,strong)UIButton *submitBtn;
@end

@implementation JKSatisfactionViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = JKBGDefaultColor;
    self.firstBtnArr = [NSMutableArray array];
    self.secondBtnArr = [NSMutableArray array];
    self.placeHolder = @"您的建议对我们非常重要哟～";
    if (self) {
        [self createSubViews];
    }
    return self;
}
-(void)createSubViews {
    [self.contentView addSubview:self.bgImageView];
    self.firstLabel = [UIView createRegularLabelWithTitle:@"您的问题是否已解决？" size:15];
    self.bgImageView.userInteractionEnabled = YES;
    [self.bgImageView addSubview:self.firstLabel];
    NSArray * titleArr = @[@"是",@"否"];
    for (int i = 0;i < 2;i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x3E3E3E) forState:UIControlStateNormal];
        if ([[UIDevice currentDevice].systemVersion doubleValue] < 9.0) {
            button.titleLabel.font =  [UIFont systemFontOfSize:14];
        }else {
            button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        }
        NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
        NSString *filePatch = [bundlePatch stringByAppendingPathComponent:@"jk_unselect"];
        UIImage *image = [UIImage imageWithContentsOfFile:filePatch];
        [button addTarget:self action:@selector(soluteChoose:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:image forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 18);
//        button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        [self.firstBtnArr addObject:button];
        [self.bgImageView addSubview:button];
    }
    self.secondLabel = [UIView createRegularLabelWithTitle:@"您对这次服务满意吗？" size:15];
    [self.bgImageView addSubview:self.secondLabel];
    
    for (int i = 0; i < 5; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
        NSString *filePatch = [bundlePatch stringByAppendingPathComponent:@"jk_star"];
        UIImage *image = [UIImage imageWithContentsOfFile:filePatch];
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chooseStar:) forControlEvents:UIControlEventTouchUpInside];
        [self.secondBtnArr addObject:button];
        [self.bgImageView addSubview:button];
    }
    self.satisLabel = [UIView createRegularLabelWithTitle:@"" size:15];
    self.satisLabel.textColor = UIColorFromRGB(0xEC5642);
    [self.bgImageView addSubview:self.satisLabel];
    
    self.thirdLabel = [UIView createRegularLabelWithTitle:@"意见反馈（非必填）" size:15];
    [self.bgImageView addSubview:self.thirdLabel];
    
    [self.bgImageView addSubview:self.textView];
    self.textView.text = self.placeHolder;
    self.textView.textColor = UIColorFromRGB(0xD5D5D5);
    
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 9.0) {
        self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }else {
        self.submitBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    }
    self.submitBtn.hidden = YES;
    [self.bgImageView addSubview:self.submitBtn];
}
-(void)soluteChoose:(UIButton *)button {
    [self WhetherSHowSubMitBtn];
    if (button.selected) {
        return;
    }
    button.selected = !button.selected;
    NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
    NSString * unselect = @"jk_unselect";
    if (button.selected) {
        unselect = @"jk_select";
    }
    NSString *filePatch = [bundlePatch stringByAppendingPathComponent:unselect];
    UIImage *image = [UIImage imageWithContentsOfFile:filePatch];
    [button setImage:image forState:UIControlStateNormal];
    for (int i = 0; i < self.firstBtnArr.count;i ++) {
        UIButton * btn = self.firstBtnArr[i];
        if ([button isEqual:btn]) {
            if (i == 0) {
                self.model.soluteNumber = SOLUTEBTN_SOLVE;
            }else{
                self.model.soluteNumber = SOLUTEBTN_UNSOLVE;
            }
            continue;
        }else {
            NSString *filePatch = [bundlePatch stringByAppendingPathComponent:@"jk_unselect"];
            UIImage *image = [UIImage imageWithContentsOfFile:filePatch];
            [btn setImage:image forState:UIControlStateNormal];
            btn.selected = NO;
        }
    }
}
-(void)chooseStar:(UIButton *)button {
    [self WhetherSHowSubMitBtn];
    NSInteger index = [self.secondBtnArr indexOfObject:button];
    self.model.startIndex = index;
    NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
    NSString *jkStart = [bundlePatch stringByAppendingPathComponent:@"jk_star"];
    NSString *jkRedStart = [bundlePatch stringByAppendingPathComponent:@"jk_redstar"];
    for (int i = 0; i < self.secondBtnArr.count; i ++) {
        UIButton * button = self.secondBtnArr[i];
        NSString * imgStr = i <=index?jkRedStart:jkStart;
        [button setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    }
    NSArray * titleArr = @[@"非常不满意",@"不满意",@"一般",@"满意",@"非常满意"];
    self.satisLabel.text = titleArr[index];
}
-(UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] init];
        NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
        NSString *filePatch = [bundlePatch stringByAppendingPathComponent:@"chatfrom_bg_normal"];
        UIImage *normal = [UIImage imageWithContentsOfFile:filePatch];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(16, 13, 16, 21)];
        _bgImageView.image = normal;
    }
    return _bgImageView;
}
-(UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = UIColorFromRGB(0xF6F6F6);
        _textView.delegate = self;
        if ([[UIDevice currentDevice].systemVersion doubleValue] < 9.0) {
            _textView.font =  [UIFont systemFontOfSize:14];
        }else {
            _textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        }
    }
    return _textView;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat minWidth =  [UIScreen mainScreen].bounds.size.width - 170 + 24;
    minWidth = minWidth < 272?272:minWidth;
    CGFloat maxHeight = self.submitBtn.hidden ? 320:353;
    self.bgImageView.frame = CGRectMake(16, 16, minWidth, maxHeight);
    self.firstLabel.frame = CGRectMake(12, 12, 160, 22);
    for (int i = 0; i < self.firstBtnArr.count; i ++) {
        UIButton * button = self.firstBtnArr[i];
        button.frame = CGRectMake(i * (38+30) + 14 , 48, 38, 20);
    }
    self.secondLabel.frame = CGRectMake(14, 94, 160, 22);
    for (int i = 0; i < self.secondBtnArr.count; i ++) {
        UIButton * button = self.secondBtnArr[i];
        button.frame = CGRectMake(i * (26+8) + 13, 132, 26, 24);
    }
    self.satisLabel.frame = CGRectMake(190, 133, CGRectGetWidth(self.bgImageView.frame)-190, 22);
    self.thirdLabel.frame = CGRectMake(14, 184, 135, 22);
    self.textView.frame = CGRectMake(14, 222, CGRectGetWidth(self.bgImageView.frame)-26, 86);
    if (!self.submitBtn.hidden) {
        self.submitBtn.frame = CGRectMake(self.bgImageView.width -80, self.bgImageView.height - 37, 68, 25);
    }
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.textView.text isEqualToString:self.placeHolder]) {
        self.textView.text = @"";
        self.textView.textColor = UIColorFromRGB(0x3E3E3E);
    }
    return YES;
}
-(void)setModel:(JKDialogModel *)model {
    if (model.isSubmit) {
        self.bgImageView.userInteractionEnabled = NO;
    }else {
        self.bgImageView.userInteractionEnabled = YES;
    }
    JKSOLUTEBTN_Click soluteState = model.soluteNumber;
    if (soluteState != SOLUTEBTN_NONE) {
        UIButton * button = soluteState == SOLUTEBTN_SOLVE?self.firstBtnArr.firstObject:self.firstBtnArr.lastObject;
        [button setImage:[UIImage imageNamed:@"jk_select"] forState:UIControlStateNormal];
        button.selected = YES;
        self.submitBtn.hidden = NO;
    }
    JKSTARTBTN_Click startState = model.startIndex;
    if (startState != STARTBTN_NONE) { //有星星
        self.submitBtn.hidden = NO;
        NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
        NSString *jkStart = [bundlePatch stringByAppendingPathComponent:@"jk_star"];
        NSString *jkRedStart = [bundlePatch stringByAppendingPathComponent:@"jk_redstar"];
        for (int i = 0; i < self.secondBtnArr.count; i ++) {
            UIButton * button = self.secondBtnArr[i];
            NSString * imgStr = i <=startState?jkRedStart:jkStart;
            [button setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
        }
        NSArray * titleArr = @[@"非常不满意",@"不满意",@"一般",@"满意",@"非常满意"];
        self.satisLabel.text = titleArr[startState];
    }
    if (model.submitContent.length) {
        self.textView.text = model.submitContent;
        self.submitBtn.hidden = NO;
    }
    if (self.model.isSubmit) {
        self.submitBtn.hidden = YES;
    }
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (self.textView.text.length <= 0) {
        self.textView.text = self.placeHolder;
        self.textView.textColor = UIColorFromRGB(0xD5D5D5);
    }
    self.model.submitContent = textView.text;
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    [self WhetherSHowSubMitBtn];
    if (textView.text.length >=100) {
        return NO;
    }
    self.model.submitContent = [NSString stringWithFormat:@"%@%@",textView.text,text];
    return YES;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)WhetherSHowSubMitBtn {
    if (!self.submitBtn.hidden) {
        return;
    }
    if (self.submitBlock) {
        self.submitBlock();
    }
}
@end
