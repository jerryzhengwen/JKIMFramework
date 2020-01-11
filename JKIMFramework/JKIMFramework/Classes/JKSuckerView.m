//
//  JKSuckerView.m
//  JKIMSDKProject
//
//  Created by Jerry on 2020/1/10.
//  Copyright © 2020 于飞. All rights reserved.
//

#import "JKSuckerView.h"
#import "JKDialogueHeader.h"
@interface JKSuckerView()
@property (nonatomic,strong)NSMutableArray *btnArr;
@end
@implementation JKSuckerView

-(instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xE8E8E8);
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}
-(void)setSurcketArr:(NSMutableArray *)surcketArr {
    _surcketArr = surcketArr;
    NSLog(@"------22222");
    dispatch_async(dispatch_get_main_queue(), ^{
    self.btnArr = [NSMutableArray array];
    for (UIView *view  in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    CGFloat margin = 12;
    CGFloat maxWidth = 16;
    for (JKSurcketModel * model in surcketArr) {
        NSString * title = model.name;
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:JKFontDefaultColor forState:UIControlStateNormal]; //计算字体的宽度
        UIFont * font =  [self getFontWithSize:14.0f];
        button.titleLabel.font = font;
        CGSize size = countStringWordWidth(title, font, CGSizeMake(MAXFLOAT, 32));
        CGFloat width = ceil(size.width) + 32;
        button.frame = CGRectMake(maxWidth, margin, width , 32);
        maxWidth = maxWidth + width + margin;
        button.backgroundColor = [UIColor whiteColor];
        button.layer.cornerRadius = 16;
        button.clipsToBounds = YES;
        [button addTarget:self action:@selector(clickSuckeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.btnArr addObject:button];
    }
        self.contentSize = CGSizeMake(maxWidth, 0);
    });
}
-(void)clickSuckeBtn:(UIButton *)button {
    if (self.suckerBlock) {
        int index = (int)[self.btnArr indexOfObject:button];
        JKSurcketModel * model = self.surcketArr[index];
        self.suckerBlock(model);
    }
}
@end
