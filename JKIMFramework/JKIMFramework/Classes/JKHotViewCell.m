//
//  JKHotViewCell.m
//  JKIMSDKProject
//
//  Created by Jerry on 2019/8/12.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKHotViewCell.h"
#import "JKDialogueHeader.h"
@interface JKHotViewCell()
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *enterImagView;
@property (nonatomic,strong)UIView *lineView;
@end

@implementation JKHotViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle =  UITableViewCellSelectionStyleNone;
        [self addSubview:self.titleLabel];
        [self addSubview:self.enterImagView];
        [self addSubview:self.lineView];
    }
    return self;
}
-(void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
    self.enterImagView.hidden = NO;
}
-(UIImageView *)enterImagView {
    if (_enterImagView == nil) {
        _enterImagView = [[UIImageView alloc] init];
        NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
        NSString *filePatch = [bundlePatch stringByAppendingPathComponent:@"jk_enter"];
        _enterImagView.image = [UIImage imageNamed:filePatch];
    }
    return _enterImagView;
}
-(UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xE5E5E5);
    }
    return _lineView;
}
-(void)setKeyWord:(NSString *)keyWord {
    _keyWord = keyWord;
    [self setContentLabelColor];
    self.enterImagView.hidden = YES;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(14, 10, self.frame.size.width - 40, 20);
    self.enterImagView.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame) - 23, 13, 8, 15);
    CGFloat minX = self.keyWord?0:4;
    self.lineView.frame = CGRectMake(minX, CGRectGetMaxY(self.contentView.frame) - 1, self.contentView.frame.size.width, 1);
}
-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        if ([[UIDevice currentDevice].systemVersion doubleValue] < 9.0) {
            _titleLabel.font =  [UIFont systemFontOfSize:15];
        }else {
            _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        }
        _titleLabel.textColor = UIColorFromRGB(0x3E3E3E);
    }
    return _titleLabel;
}

/**
 改变UILabel部分字符颜色
 */
- (void)setContentLabelColor {
    NSMutableArray *locationArr = [self calculateSubStringCount:self.title   str:self.keyWord];
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:self.title];
    for (int i=0; i<locationArr.count; i++) {
        if (i%2==0) {
            NSNumber *location = locationArr[i];
            [attstr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(location.intValue, self.keyWord.length)];//改变\n前边的10位字符颜色，
        }
    }
    self.titleLabel.attributedText = attstr;
}

/**
 查找子字符串在父字符串中的所有位置
 @param content 父字符串
 @param tab 子字符串
 @return 返回位置数组
 */
-(NSMutableArray*)calculateSubStringCount:(NSString *)content str:(NSString *)tab {
    int location = 0;
    NSMutableArray *locationArr = [NSMutableArray new];
    NSRange range = [content rangeOfString:tab];
    if (range.location == NSNotFound){
        return locationArr;
    }
    //声明一个临时字符串,记录截取之后的字符串
    NSString * subStr = content;
    while (range.location != NSNotFound) {
        if (location == 0) {
            location += range.location;
        } else {
            location += range.location + tab.length;
        }
        //记录位置
        NSNumber *number = [NSNumber numberWithUnsignedInteger:location];
        [locationArr addObject:number];
        //每次记录之后,把找到的字串截取掉
        subStr = [subStr substringFromIndex:range.location + range.length];
        range = [subStr rangeOfString:tab];
    }
    return locationArr;
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
