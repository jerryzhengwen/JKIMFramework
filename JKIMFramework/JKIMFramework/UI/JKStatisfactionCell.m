//
//  JKStatisfactionCell.m
//  JKIMSDKProject
//
//  Created by Jerry on 2019/4/19.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKStatisfactionCell.h"
#import "JKBundleTool.h"
#import "UIView+JKFloatFrame.h"
@interface JKStatisfactionCell() <UITextViewDelegate>
@property (nonatomic,strong) UITextView * textView;
@property (nonatomic,strong) UIImageView * selectView;
@end

@implementation JKStatisfactionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor whiteColor];
    if (self) {
        [self.contentView addSubview:self.textView];
    }
    return self;
}
- (void)setModel:(JKSatisfactionModel *)model {
    _model = model;
    self.textLabel.hidden = NO;
    if (model.isTextView) {
        self.textView.hidden = NO;
        self.textLabel.hidden =  YES;
        if (model.content.length) {
            self.textView.text = model.content;
            self.textView.textColor = [UIColor blackColor];
        }else {
            self.textView.text = model.name;
            self.textView.textColor = RGBColor(120, 120, 120, 1);
        }
    }else {
        self.textView.hidden = YES;
        self.textLabel.text = model.name;
        self.textLabel.textColor = RGBColor(91, 91, 91, 1);
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.accessoryView = self.selectView;
        self.accessoryView.hidden = !model.showSelect;
    }
    
}
-(UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.hidden = YES;
    }
    return _textView;
}
-(UIImageView *)selectView {
    if (_selectView == nil) {
        _selectView = [[UIImageView alloc] init];
        NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
        NSString *filePatch = [bundlePatch stringByAppendingPathComponent:@"jkselectedIcon"];
        _selectView.image = [UIImage imageWithContentsOfFile:filePatch];
    }
    return _selectView;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    if (self.model.isTextView) {
        self.textView.frame = CGRectMake(0, 0, self.width, 150);
    }else {
        self.accessoryView.frame = CGRectMake(self.width - 50, 16, 11.5, 12.5);
        self.textLabel.frame = CGRectMake(10, 0, self.width - 60, 44);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:self.model.name]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView {
    if (!textView.text.length) {
        self.textView.text = self.model.name;
        self.model.content = @"";
        self.textView.textColor = RGBColor(120, 120, 120, 1);
        return;
    }
    self.model.content = textView.text; 
}
@end
