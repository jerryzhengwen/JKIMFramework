//
//  JKSatisfactionViewController.m
//  JKIMSDKProject
//
//  Created by Jerry on 2019/4/19.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKSatisfactionViewController.h"
#import "JKSatisfactionModel.h"
#import "JKStatisfactionCell.h"
@interface JKSatisfactionViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation JKSatisfactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"提交满意度";
    __weak typeof(self) weakSelf = self;
    [[JKConnectCenter sharedJKConnectCenter] getSatisfactionWithBlock:^(id  _Nullable result) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if (array.count) {
            for (int i  = 0; i < array.count; i++) {
                JKSatisfactionModel * model = [[JKSatisfactionModel alloc] init];
                if ([array[i] valueForKey:@"name"] && [array[i] valueForKey:@"pk"]) {
                    if (i == 0) {
                        JKSatisfactionModel *firstModel = [[JKSatisfactionModel alloc] init];
                        model.canClick = NO;
                        firstModel.name = @"您对本次服务满意吗？";
                        [weakSelf.dataArray addObject:firstModel];
                    }
                    model.name = array[i][@"name"];
                    model.pk = array[i][@"pk"];
                    model.canClick = YES;
                    [weakSelf.dataArray addObject:model];
                }
                if (i == array.count - 1 && weakSelf.dataArray.count > 0) {
                    JKSatisfactionModel * model = [[JKSatisfactionModel alloc] init];
                    model.canClick = NO;
                    model.isTextView = YES;
                    model.name = @"请输入详情";
                    [weakSelf.dataArray addObject:model];
                }
            }
        }
        if (weakSelf.dataArray.count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }else {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
//    NSArray * titleArray= @[@"您对本次服务满意吗？",@"满意",@"一般",@"不满意",@"还行",@"请输入详情"];
//    for (int i = 0; i < titleArray.count; i ++) {
//        JKSatisfactionModel * model = [[JKSatisfactionModel alloc] init];
//        model.name = titleArray[i];
//        model.canClick = YES;
//        if (i == 0 || i == titleArray.count - 1 ) {
//            model.canClick = NO;
//        }
//        if (i == titleArray.count - 1) {
//            model.isTextView = YES;
//        }
//        [self.dataArray addObject:model];
//    }
    [self createSubmitBtn];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    CGFloat safeSeparation = kStatusBarAndNavigationBarHeight == 88?24: 0;
    self.tableView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight, self.view.width, self.view.height-kStatusBarAndNavigationBarHeight - 40 - safeSeparation);
    self.view.backgroundColor = RGBColor(230, 230, 230, 1);
    self.tableView.backgroundColor = RGBColor(230, 230, 230, 1);
}
-(void)createSubmitBtn {
    CGFloat safeSeparation = kStatusBarAndNavigationBarHeight == 88?24: 0;
    for (int i = 0; i < 2; i ++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString * title = i== 0? @"取消":@"确定";
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:RGBColor(236, 86, 66, 1) forState:UIControlStateNormal];
        btn.frame = CGRectMake(i *self.view.middleX, self.view.bottom - 40 - safeSeparation, self.view.width/2, 40);
        [self.view addSubview:btn];
        UIView * lineView = [[UIView alloc] init];
        lineView.backgroundColor = RGBColor(172, 172, 172, 1);
        [self.view addSubview:lineView];
        if (i == 0) {
            lineView.frame = CGRectMake(0, btn.top, self.view.width, 1);
        }else {
            lineView.frame = CGRectMake(self.view.middleX, btn.top, 1, btn.height);
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
-(void)btnClick:(UIButton *)button {
    [self.view endEditing:YES];
    if ([button.titleLabel.text isEqualToString:@"取消"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else { //调接口
        for (JKSatisfactionModel * model in self.dataArray) {
            if (model.showSelect) { // 在这里调用接口
                JKSatisfactionModel * lastModel = self.dataArray.lastObject;
                NSString * pk = model.pk?model.pk:@"";
                NSString *memo = lastModel.content?lastModel.content:@"";
                NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[pk,memo] forKeys:@[@"pk",@"memo"]];
                __weak typeof(self) weakSelf = self;
                [[JKConnectCenter sharedJKConnectCenter] submitSatisfactionWithDict:dict Block:^(id  _Nullable result) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (weakSelf.returnMessageBlock) { weakSelf.returnMessageBlock(model.name);
                        }
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    });
                }];
            }
        }
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataArray.count - 1;
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifer = @"cell";
    JKStatisfactionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[JKStatisfactionCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    if (indexPath.section == 0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    cell.model = indexPath.section == 0 ?self.dataArray[indexPath.row]:self.dataArray.lastObject;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JKSatisfactionModel * model = self.dataArray[indexPath.row];
    if (!model.canClick) {
        return;
    }
    for (int i = 0; i < self.dataArray.count; i ++) {
        JKSatisfactionModel * model = self.dataArray[i];
        model.showSelect = NO;
        if (i == indexPath.row) {
            model.showSelect = YES;
        }
    }
    [self.tableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView eorRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 44: 150;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] init];
    if (section == 0) {
        UILabel * content = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 30, 30)];
        content.text = self.content;
        content.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [view addSubview:content];
    }
    return view;
}
@end
