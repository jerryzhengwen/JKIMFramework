//
//  JKHotMessageCell.m
//  JKIMSDKProject
//
//  Created by Jerry on 2019/8/12.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKHotMessageCell.h"


@interface JKHotMessageCell();

@end

@implementation JKHotMessageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}
-(void)createSubViews {
    [self.contentView addSubview:self.hotView];
}
-(void)setModel:(JKDialogModel *)model {
    _model = model;
    self.hotView.isClarify = model.messageType == JKMessageClarify?YES:NO;
    self.hotView.hotArray = model.hotArray;
}
-(JKHotView *)hotView {
    if (_hotView == nil) {
        _hotView = [[JKHotView alloc] init];
    }
    return _hotView;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    self.hotView.frame = CGRectMake(16, 30, self.frame.size.width - 32, self.model.hotArray.count *46);
    self.hotView.layer.cornerRadius = 12;
    self.hotView.clipsToBounds = YES;
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
