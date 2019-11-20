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
#import "JKSatisfactionModel.h"
@interface JKSatisfactionViewCell()<UITextViewDelegate>
@property (nonatomic,strong)UIImageView *bgImageView;
@property (nonatomic,strong)UILabel *firstLabel;
@property (nonatomic,strong)NSMutableArray *firstBtnArr;
@property (nonatomic,strong)NSMutableArray *secondBtnArr;
@property (nonatomic,strong)UILabel *secondLabel;
@property (nonatomic,strong)UILabel *satisLabel;
@property (nonatomic,strong)UILabel *thirdLabel;
@property (nonatomic,strong)UITextView *adviseTV;
@property (nonatomic,copy) NSString *placeHolder;
@property (nonatomic,strong)UIButton *submitBtn;
@end

@implementation JKSatisfactionViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = JKBGDefaultColor;
    self.userInteractionEnabled = YES;
    self.placeHolder = @"您的建议对我们非常重要哟～";
    if (self) {
        [self createSubViews];
    }
    return self;
}
-(void)setModel:(JKMessageFrame *)model {
    _model = model;
    self.firstBtnArr = [NSMutableArray array];
    self.secondBtnArr = [NSMutableArray array];
    if (model.isSubmit) {
        self.bgImageView.userInteractionEnabled = NO;
    }else {
        self.bgImageView.userInteractionEnabled = YES;
    }
    for (int i = 0;i < model.soluteArr.count;i++) {
        JKSatisfactionModel * soluteModel = model.soluteArr[i];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:soluteModel.name forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x3E3E3E) forState:UIControlStateNormal];
        if ([[UIDevice currentDevice].systemVersion doubleValue] < 9.0) {
            button.titleLabel.font =  [UIFont systemFontOfSize:14];
        }else {
            button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        }
        NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
        NSString *imgStr = soluteModel.showSelect?@"jk_select":@"jk_unselect";
        NSString *filePatch  = [bundlePatch stringByAppendingPathComponent:imgStr];
        UIImage *image = [UIImage imageWithContentsOfFile:filePatch];
        [button addTarget:self action:@selector(soluteChoose:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:image forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4);
        [self.firstBtnArr addObject:button];
        [self.bgImageView addSubview:button];
    }
    
    int selectNum = -1;
    self.satisLabel.text = @"";
    for (int i = 0; i < model.satisArr.count; i++) { //判断一下是否选中？
        JKSatisfactionModel * satisModel = model.satisArr[i];
        if (satisModel.showSelect) {
            selectNum = i;
            self.satisLabel.text = satisModel.name;
        }
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
        NSString *filePatch = [bundlePatch stringByAppendingPathComponent:@"jk_star"];
        UIImage *image = [UIImage imageWithContentsOfFile:filePatch];
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chooseStar:) forControlEvents:UIControlEventTouchUpInside];
        [self.secondBtnArr addObject:button];
        [self.bgImageView addSubview:button];
    }
    if (selectNum >= 0) {
        for (int i = 0; i <= selectNum; i++) {
            UIButton * button = self.secondBtnArr[i];
            NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
            NSString *filePatch = [bundlePatch stringByAppendingPathComponent:@"jk_redstar"];
            UIImage *image = [UIImage imageWithContentsOfFile:filePatch];
            [button setImage:image forState:UIControlStateNormal];
        }
    }
    [self.bgImageView addSubview:self.submitBtn];
    if (model.content.length) {
        self.adviseTV.text = model.content;
    }else {
        self.adviseTV.text = self.placeHolder;
        self.adviseTV.textColor = UIColorFromRGB(0xD5D5D5);
    }
    if (model.isSubmit) {
        self.submitBtn.hidden = YES;
    }else {
        BOOL isShow = model.content.length?YES:NO;
        for (JKSatisfactionModel * satisModel  in model.satisArr) {
            if (satisModel.showSelect || isShow) {
                isShow = YES;
                break;
            }
        }
        for (JKSatisfactionModel * soluteModel  in model.soluteArr) {
            if (soluteModel.showSelect || isShow) {
                isShow = YES;
                break;
            }
        }
        self.submitBtn.hidden = !isShow;
    }
    self.firstLabel.hidden = model.soluteArr.count == 0 ?YES:NO;
    self.secondLabel.hidden = model.satisArr.count == 0 ?YES:NO;
    if (model.isFirstResign) {
         [self.adviseTV becomeFirstResponder];
    }
}
-(void)createSubViews {
    [self.contentView addSubview:self.bgImageView];
    self.firstLabel = [UIView createRegularLabelWithTitle:@"您的问题是否已解决？" size:15];
    self.bgImageView.userInteractionEnabled = YES;
    [self.bgImageView addSubview:self.firstLabel];
    
    self.secondLabel = [UIView createRegularLabelWithTitle:@"您对这次服务满意吗？" size:15];
    [self.bgImageView addSubview:self.secondLabel];
    
    self.satisLabel = [UIView createRegularLabelWithTitle:@"" size:15];
    self.satisLabel.textColor = UIColorFromRGB(0xEC5642);
    [self.bgImageView addSubview:self.satisLabel];
    
    self.thirdLabel = [UIView createRegularLabelWithTitle:@"意见反馈（非必填）" size:15];
    [self.bgImageView addSubview:self.thirdLabel];
    
    [self.bgImageView addSubview:self.adviseTV];
    self.adviseTV.text = self.placeHolder;
    self.adviseTV.textColor = UIColorFromRGB(0xD5D5D5);
    
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitBtn.layer.cornerRadius = 14;
    self.submitBtn.clipsToBounds = YES;
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 68, 25);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.5),@(1.0)];//渐变点
    [gradientLayer setColors:@[(id)UIColorFromRGB(0xFF8E48).CGColor,(id)UIColorFromRGB(0xFF6262).CGColor]];//渐变数组
    [self.submitBtn.layer addSublayer:gradientLayer];
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 9.0) {
        self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }else {
        self.submitBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    }
    self.submitBtn.hidden = YES;
}
-(void)submitClick {
    if (self.submitClicked) {
        self.submitClicked(self.model);
    }
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
        JKSatisfactionModel * model = self.model.soluteArr[i];
        if ([button isEqual:btn]) {
            model.showSelect = YES;
            continue;
        }else {
            NSString *filePatch = [bundlePatch stringByAppendingPathComponent:@"jk_unselect"];
            UIImage *image = [UIImage imageWithContentsOfFile:filePatch];
            [btn setImage:image forState:UIControlStateNormal];
            btn.selected = NO;
            model.showSelect = NO;
        }
    }
}
-(void)chooseStar:(UIButton *)button {
    [self WhetherSHowSubMitBtn];
    NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
    NSString *jkStart = [bundlePatch stringByAppendingPathComponent:@"jk_star"];
    NSString *jkRedStart = [bundlePatch stringByAppendingPathComponent:@"jk_redstar"];
    int selectIndex = (int)[self.secondBtnArr indexOfObject:button];
    for (int i = 0; i < self.secondBtnArr.count; i ++) {
        JKSatisfactionModel * satisModel = self.model.satisArr[i];
        if (i == selectIndex) {
            satisModel.showSelect = YES;
            self.satisLabel.text = satisModel.name;
        }else {
            satisModel.showSelect = NO;
        }
        UIButton * button = self.secondBtnArr[i];
        NSString * imgStr = i <= selectIndex?jkRedStart:jkStart;
        [button setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    }
}
-(UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] init];
//        NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
//        NSString *filePatch = [bundlePatch stringByAppendingPathComponent:@"chatfrom_bg_normal"];
//        UIImage *normal = [UIImage imageWithContentsOfFile:filePatch];
//        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(16, 13, 16, 21)];
//        _bgImageView.image = normal;
    }
    return _bgImageView;
}
-(UITextView *)adviseTV {
    if (!_adviseTV) {
        _adviseTV = [[UITextView alloc] init];
        _adviseTV.backgroundColor = UIColorFromRGB(0xF6F6F6);
        _adviseTV.delegate = self;
        if ([[UIDevice currentDevice].systemVersion doubleValue] < 9.0) {
            _adviseTV.font =  [UIFont systemFontOfSize:11];
        }else {
            _adviseTV.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        }
    }
    return _adviseTV;
}
CGSize countStringWordWidth(NSString *aString,UIFont * font, CGSize labelSize) {
    
    CGSize size =[aString
                  boundingRectWithSize:labelSize
                  options:NSStringDrawingUsesLineFragmentOrigin
                  attributes:@{NSFontAttributeName:font}
                  context:nil].size;
    return size;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat minWidth =  [UIScreen mainScreen].bounds.size.width - 103 + 24;
    minWidth = minWidth < 272?272:minWidth;
    CGFloat minHight = 12;
    if (self.firstBtnArr.count > 0) {
        self.firstLabel.frame = CGRectMake(minHight, minHight, 160, 22);
        minHight = minHight + 22 + 14;
        UIFont  *font ;
        if ([[UIDevice currentDevice].systemVersion doubleValue] < 9.0) {
            font =  [UIFont systemFontOfSize:15];
        }else {
            font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        }
        CGFloat minWidth = 14;
        for (int i = 0; i < self.model.soluteArr.count; i ++) {
            JKSatisfactionModel * soluteModel = self.model.soluteArr[i];
            UIButton * button = self.firstBtnArr[i];
            CGSize size = countStringWordWidth(soluteModel.name, font, CGSizeMake(272, 20));
            CGFloat btnWth = ceil(size.width) + 24;
            button.frame = CGRectMake(minWidth , minHight, btnWth, 20);
            minWidth = minWidth + btnWth + 14;
        }
        minHight = minHight + 20 + 26;
    }
    if (self.secondBtnArr.count > 0) {
        self.secondLabel.frame = CGRectMake(14, minHight, 160, 22);
        minHight = minHight + 22 + 16;
        
        for (int i = 0; i < self.secondBtnArr.count; i ++) {
            UIButton * button = self.secondBtnArr[i];
            button.frame = CGRectMake(i * (26+8) + 13, minHight, 26, 24);
        }
        self.satisLabel.frame = CGRectMake(190, minHight, minWidth -190, 22);
        minHight = minHight + 24 + 28;
    }
    self.thirdLabel.frame = CGRectMake(14, minHight, 135, 22);
    minHight = minHight + 22 + 16;
    self.adviseTV.frame = CGRectMake(14, minHight, minWidth -26, 86);
    minHight = minHight + 86;
    if (!self.submitBtn.hidden) {
        minHight = minHight + 8;
        self.submitBtn.frame = CGRectMake(minWidth -80, minHight, 68, 25);
        minHight = minHight + 25;
    }
    minHight = minHight + 12;
    self.bgImageView.frame = CGRectMake(16, 16, minWidth, minHight);
    
    self.bgImageView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgImageView.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bgImageView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bgImageView.layer.mask = maskLayer;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.adviseTV.text isEqualToString:self.placeHolder]) {
        self.adviseTV.text = @"";
        self.adviseTV.textColor = UIColorFromRGB(0x3E3E3E);
    }
    self.model.isFirstResign = YES;
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView {
    if (![self.placeHolder isEqualToString:textView.text]) {
     self.model.content = textView.text;
    }else {
        self.model.content = @"";
    }
    if (self.adviseTV.text.length <= 0) {
        self.adviseTV.text = self.placeHolder;
        self.adviseTV.textColor = UIColorFromRGB(0xD5D5D5);
    }
    self.model.isFirstResign = NO;
    [self WhetherSHowSubMitBtn];
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (self.adviseTV.text.length <= 0) {
        self.adviseTV.text = self.placeHolder;
        self.adviseTV.textColor = UIColorFromRGB(0xD5D5D5);
    }
    self.model.content = textView.text;
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.text.length >=100 && text.length) {
        return NO;
    }
//    self.model.content = [NSString stringWithFormat:@"%@%@",textView.text,text];
    return YES;
}
//-(void)textViewDidChange:(UITextView *)textView {
//    //    textview 改变字体的行间距
//
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//
//    paragraphStyle.lineSpacing = 14;// 字体的行间距
//
//    NSDictionary *attributes = @{
//
//                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
//
//                                 NSParagraphStyleAttributeName:paragraphStyle
//
//                                 };
//
//    self.adviseTV.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
//}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)WhetherSHowSubMitBtn {
//    if (!self.submitBtn.hidden) {
//        return;
//    }
    if (self.submitBlock) {
        self.submitBlock();
    }

}
@end
