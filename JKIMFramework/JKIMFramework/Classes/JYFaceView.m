//
//  JYFaceView.m
//  JKIMSDKProject
//
//  Created by Jerry on 2019/3/19.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JYFaceView.h" //176

@interface JYFaceView ()
@property (nonatomic,strong)NSArray *titleArray;
@end

@implementation JYFaceView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createFaceImageBtn];
        self.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:244/255.0 alpha:1];
        self.titleArray = @[@"[微笑]",@"[调皮]",@"[可爱]",@"[呲牙]",@"[尴尬]",@"[疑问]",@"[害羞]",@"[憨笑]",@"[委屈]",@"[酷]",@"[奋斗]",@"[亲亲]",@"[强]",@"[鼓掌]",@"[再见]",@"[OK]",@"[握手]",@"[太阳]",@"[玫瑰]",@"[爱心]",@"[拥抱]", @"[撇嘴]"];
    }
    return self;
}
-(void)createFaceImageBtn{
    CGFloat buttonWidth = 40;
    CGFloat heightMargin = (145 - 120)/4;
    CGFloat widmargin = (self.frame.size.width-7*40)/8;
    NSString *bundlePatch =  [[NSBundle bundleForClass:[self class]]pathForResource:@"JKIMImage" ofType:@"bundle"];
    NSArray *faceArray =@[@"Expression_1",@"Expression_13",@"Expression_22",@"Expression_14",@"Expression_11",@"Expression_33",@"Expression_7",@"Expression_29",@"Expression_50",@"Expression_17",@"Expression_31",@"Expression_53",@"Expression_80",@"Expression_43",@"Expression_40",@"Expression_90",@"Expression_82",@"Expression_77",@"Expression_64",@"Expression_67",@"Expression_79"];
    for (int i = 0; i < 21; i ++ ) {
        NSString *filePatch = [bundlePatch stringByAppendingPathComponent:faceArray[i]];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 333 +i;
        button.frame = CGRectMake(widmargin + (i%7)*(buttonWidth + widmargin), heightMargin +(i/7)*(buttonWidth + heightMargin), buttonWidth, buttonWidth);
        [button setImage:[UIImage imageWithContentsOfFile:filePatch] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonChooseImage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}
-(void)buttonChooseImage:(UIButton *)button {
    if (self.clickBlock) {
        int index = (int)button.tag - 333;
        self.clickBlock(self.titleArray[index]);
    }
}
@end
