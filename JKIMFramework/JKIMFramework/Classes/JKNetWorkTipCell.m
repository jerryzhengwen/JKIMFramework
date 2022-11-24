//
//  JKNetWorkTipCell.m
//  JKIMSDKProject
//
//  Created by 陈天栋 on 2022/11/24.
//  Copyright © 2022 于飞. All rights reserved.
//

#import "JKNetWorkTipCell.h"
#import "JKDialogueHeader.h"

@interface JKNetWorkTipCell ()

@property (nonatomic,strong)UILabel * tipLabel;

@end


@implementation JKNetWorkTipCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = JKBGDefaultColor;
    if (self) {
        [self.contentView addSubview:self.tipLabel];
    }
    return self;
}

-(void)setMessageFrame:(JKMessageFrame *)messageFrame{
    _messageFrame = messageFrame;
    NSLog(@"%@",messageFrame);
    self.tipLabel.text = messageFrame.message.content;
    //self.tipLabel.frame = self.frame;
    self.tipLabel.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, messageFrame.cellHeight);
}
-(UILabel *)tipLabel{
    if (_tipLabel == nil){
        _tipLabel = [[UILabel alloc] initWithFrame:self.frame];
        if ([[UIDevice currentDevice].systemVersion doubleValue] < 9.0) {
            _tipLabel.font =  [UIFont systemFontOfSize:15];
        }else {
            _tipLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        }
        _tipLabel.numberOfLines = 0;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = UIColorFromRGB(0x9B9B9B);
    }
    return _tipLabel;
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
