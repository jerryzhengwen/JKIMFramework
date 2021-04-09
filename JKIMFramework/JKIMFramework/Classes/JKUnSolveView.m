//
//  JKUnSolveView.m
//  JKIMSDKProject
//
//  Created by Jerry on 2021/3/25.
//  Copyright © 2021 于飞. All rights reserved.
//

#import "JKUnSolveView.h"
#import "JKDialogueHeader.h"
#import "JKUnSolveCell.h"
#import "JKPluginModel.h"
#import "JKLabHUD.h"
@interface JKUnSolveView()<UITableViewDelegate,UITableViewDataSource>
/**
 数据源
 */
@property (nonatomic,strong)NSMutableArray *dataArray;
/**
 底部的白色View
 */
@property (nonatomic,strong)UIView *whiteView;

/**
 关闭按钮
 */
@property (nonatomic,strong)UIButton *closeBtn;
/**
 提交按钮
 */
@property (nonatomic,strong)UIButton *subimtBtn;
/**
 tableView
 */
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation JKUnSolveView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self createOtherView];
    }
    return self;
}
-(void)setTitleArr:(NSArray *)titleArr {
    _titleArr = titleArr;
    self.dataArray = [NSMutableArray array];
    for (NSString *title in titleArr) {
        JKPluginModel *model = [[JKPluginModel alloc] init];
        model.title = title;
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
}
-(void)stopGesture {}
-(void)clickSelf{
    if (self.clickTipsBlock) {
        self.clickTipsBlock(@"");
    }
    [self removeFromSuperview];
}
-(void)createOtherView {
    CGFloat margin = kStatusBarAndNavigationBarHeight == 64?0:33;
    self.whiteView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(self.frame) -310 -margin , CGRectGetWidth(self.frame), 310)];
    self.whiteView.backgroundColor = [UIColor whiteColor];
    self.whiteView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopGesture)];
    self.whiteView.gestureRecognizers = @[gesture];
    [self addSubview:self.whiteView];
    NSArray * titleArr = @[@"关闭",@"意见反馈",@"提交"];
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        if (i != 2) {
            [button setTitleColor:UIColorFromRGB(0x9B9B9B) forState:UIControlStateNormal];
        }else {
            [button setTitleColor:UIColorFromRGB(0xEC5642) forState:UIControlStateNormal];
        }
        if (i != 1) {
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                self.closeBtn = button;
                button.frame = CGRectMake(10, 5, 60, 40);
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            }else {
                self.subimtBtn = button;
                button.frame = CGRectMake(CGRectGetWidth(self.whiteView.frame) -70, 5, 60, 40);
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            }
        }else {
            button.frame = CGRectMake(CGRectGetMidX(self.whiteView.frame) - 50, 5, 100, 40);
        }
        [self.whiteView addSubview:button];
    }
    [self addSubview:self.tableView];
    UIView *frontView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetMinY(self.whiteView.frame))];
    frontView.backgroundColor = UIColor.clearColor;
    frontView.userInteractionEnabled = YES;
    UITapGestureRecognizer *frontGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSelf)];
    frontView.gestureRecognizers =@[frontGesture];
    [self addSubview:frontView];
}
-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.whiteView.frame) + 60, CGRectGetWidth(self.whiteView.frame), 250) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"UItableViewcell";
    JKUnSolveCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[JKUnSolveCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = 0;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (JKPluginModel * model in self.dataArray) {
        model.isSeleted = NO;
    }
    JKPluginModel *model = self.dataArray[indexPath.row];
    model.isSeleted  = YES;
    [self.tableView reloadData];
}
-(void)buttonAction:(UIButton *)button {
    NSString *selectTips = @"";
    if ([self.subimtBtn isEqual:button]) {//提交按钮
        BOOL isSelected = NO;
        for (JKPluginModel * model in self.dataArray) {
            if (model.isSeleted) {
                isSelected = YES;
                selectTips = model.title;
                break;
            }
        }
        if (!isSelected) {
            dispatch_async(dispatch_get_main_queue(), ^{
               [[JKLabHUD shareHUD] showWithMsg:@"请选择反馈原因"];
            });
            return;
        }
    }
    if (self.clickTipsBlock) {
        self.clickTipsBlock(selectTips);
    }
    [self removeFromSuperview];
}
@end
