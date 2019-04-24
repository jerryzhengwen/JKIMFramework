//
//  JKPluginView.m
//  JKIMSDKProject
//
//  Created by Jerry on 2019/4/2.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKPluginView.h"
#import "UIView+JKFloatFrame.h"
#import "RegexKitLite.h"
#import "JKPluginModel.h"
#import "JK_YYWebImage.h"
#import "JKBundleTool.h"
@interface JKPluginView()

@end

@implementation JKPluginView
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:244/255.0 alpha:1];
    }
    return self;
}
-(void)setPlugArray:(NSArray *)plugArray {
    _plugArray = plugArray;
    [self createOtherView];
}
-(void)createOtherView {
    CGFloat width  = 45;
    CGFloat margin = (self.width - width * 4)/5;
    CGFloat heightMargin = (self.height - (width+10)*2)/3;
    for (int i = 0; i <_plugArray.count; i++) {
        JKPluginModel * model = _plugArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        int j = i;
        CGFloat otherWidth = 0;
        if (j >= 8) {
            otherWidth = self.width * (j/8);
            j = j % 8;
        }
        button.frame = CGRectMake(margin + (j%4) *(width + margin)+otherWidth, heightMargin +(j/4)*(width + 10 + 13+ heightMargin), width, width);
        button.tag = 200 + i;
        if (model.iconUrl) {
            NSArray *cmpsArr = [model.iconUrl componentsMatchedByRegex:@"^((https|http|ftp|rtsp|mms)?:\\/\\/)[^\\s]+"];
            if (!cmpsArr.count) {
                NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
                NSString *filePatch =  [bundlePatch stringByAppendingPathComponent:model.iconUrl];
            [button setImage:[UIImage imageWithContentsOfFile:filePatch] forState:UIControlStateNormal];
//                [button yy_setImageWithURL:[NSURL fileURLWithPath:filePatch] forState:UIControlStateNormal options:0];
            }else {
               button.imageView.yy_imageURL = [NSURL URLWithString:model.iconUrl];
            }
        }
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    int number = (int)self.plugArray.count;
    if (number > 8) {
        self.contentSize = CGSizeMake(self.width *(number/8 +1), 0);
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
    }
}
-(void)buttonClick:(UIButton *)button {
    int number = (int)button.tag - 200;
    if (self.clickBlock) {
        self.clickBlock(number);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
