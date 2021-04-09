//
//  JKUnSolveCell.m
//  JKIMSDKProject
//
//  Created by Jerry on 2021/3/25.
//  Copyright © 2021 于飞. All rights reserved.
//

#import "JKUnSolveCell.h"
#import "JKDialogueHeader.h"
@interface JKUnSolveCell()
/**
 内容Label
 */
@property (nonatomic,strong)UILabel *titleLabel;
/**
 分割线
 */
@property (nonatomic,strong)UIView *lineView;
/**
 右边文本label
 */
@property (nonatomic,strong)UILabel *rightLabel;
@end
@implementation JKUnSolveCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}
-(UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
-(UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xF6F6F6);
    }
    return _lineView;
}
-(UILabel *)rightLabel {
    if (_rightLabel == nil) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        _rightLabel.textColor = UIColorFromRGB(0xEC5642);
        _rightLabel.text = @"✓";
    }
    return _rightLabel;
}
-(void)createSubViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.rightLabel];
}
-(void)setModel:(JKPluginModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.rightLabel.hidden = !model.isSeleted;
    if (model.isSeleted) {
        self.titleLabel.textColor = UIColorFromRGB(0xEC5642);
    }else {
        self.titleLabel.textColor = UIColor.blackColor;
    }
}
-(void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(50, 0, CGRectGetWidth(self.contentView.frame) - 100, 50);
    self.lineView.frame = CGRectMake(0, 49.5, CGRectGetWidth(self.contentView.frame), 0.5);
    self.rightLabel.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 30, 0, 20, 50);
}
@end
