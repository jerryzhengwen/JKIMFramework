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
@property (nonatomic,strong)UITableView * satisTableView;
@property (nonatomic,strong)NSMutableArray *sectionOneArr;
@property (nonatomic,strong)NSMutableArray *sectionTwoArr;

@end

@implementation JKSatisfactionViewController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"提交满意度";
    self.sectionOneArr = [NSMutableArray array];
    self.sectionTwoArr = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    [[JKConnectCenter sharedJKConnectCenter] getSatisfactionWithBlock:^(id  _Nullable result) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if ([[array superclass] isKindOfClass:[NSMutableDictionary class]]) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            return ;
        }
        if (array.count) { //双层数组
            for (int i = 0;i <array.count;i ++) {
                NSArray *satisArr = array[i];
                for (int j  = 0; j < satisArr.count; j++) {
                    if ([satisArr[j] valueForKey:@"name"] && [satisArr[j] valueForKey:@"pk"]) {
                        JKSatisfactionModel * model = [[JKSatisfactionModel alloc] init];
                        model.name = satisArr[j][@"name"];
                        model.pk = satisArr[j][@"pk"];
                        model.canClick = YES;
                        model.showSelect = j == 0?YES:NO;
                        if (i == 0) {
                            if (j == 0) {
                                JKSatisfactionModel *firstModel = [[JKSatisfactionModel alloc] init];
                                firstModel.canClick = NO;
                                firstModel.name = @"您对本次服务满意吗？";
                                [weakSelf.sectionOneArr addObject:firstModel];
                            }
                            [weakSelf.sectionOneArr addObject:model];
                        }else{
                          [weakSelf.sectionTwoArr addObject:model];
                        }
                    }
                }
                if (i == array.count - 1) {
                    JKSatisfactionModel * model = [[JKSatisfactionModel alloc] init];
                    model.canClick = NO;
                    model.isTextView = YES;
                    model.name = @"请输入详情";
                    [weakSelf.sectionTwoArr addObject:model];
                }
            }
        }
        if (weakSelf.sectionOneArr.count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.satisTableView reloadData];
            });
        }else {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
    [self createSubmitBtn];
    [self.view addSubview:self.satisTableView];
    CGFloat safeSeparation = kStatusBarAndNavigationBarHeight == 88?24: 0;
    self.satisTableView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight, self.view.width, self.view.height-kStatusBarAndNavigationBarHeight - safeSeparation - 40);
    self.view.backgroundColor = RGBColor(230, 230, 230, 1);
    self.satisTableView.backgroundColor = RGBColor(230, 230, 230, 1);
    [self initGestureWithTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    self.satisTableView.tableFooterView = [[UIView alloc] init];
}
- (void)UIKeyboardWillShowNotification:(NSNotification *)noti {
    double duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    NSDictionary *dict = [noti userInfo];
    NSValue *frameValue = [dict valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [frameValue CGRectValue];
    CGFloat height = CGRectGetHeight(rect);
    [UIView animateWithDuration:duration animations:^{
        CGRect rect1 = self.view.frame;
        rect1.origin.y = 0 -height;
        self.view.frame = rect1;
    }];
}
- (void)keyBoardWillHidden:(NSNotification *)noti {
    double duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat safeSeparation = 0.0f;
    if (kStatusBarAndNavigationBarHeight == 88) {
        safeSeparation = 24.0f;
    }
    [UIView animateWithDuration:duration animations:^{
        CGRect rect1 = self.view.frame;
        rect1.origin.y = 0;
        self.view.frame = rect1;
    }];
}

-(void)initGestureWithTableView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addToucheEvent:)];
    [self.satisTableView addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
}
- (void)addToucheEvent:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
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
        NSString * satisfactionPk = @"";
        NSString * solutionPk = @"";
        NSString * name = @"";
        for (JKSatisfactionModel * model in self.sectionOneArr) {
            if (model.showSelect) { // 在这里调用接口
                satisfactionPk = model.pk;
                name = model.name;
            }
        }
        for (JKSatisfactionModel * model in self.sectionTwoArr) {
            if (model.showSelect) {
                solutionPk = model.pk;
                if (!name.length) {
                    name = model.name;
                }
            }
        }
        JKSatisfactionModel * lastModel = self.sectionTwoArr.lastObject;
        NSString *memo = lastModel.content?lastModel.content:@"";
        NSString *context_id = self.context_id;
        NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[satisfactionPk,solutionPk,memo,context_id] forKeys:@[@"satisfactionPk",@"solutionPk",@"memo",@"context_id"]];
        __weak typeof(self) weakSelf = self;
        [[JKConnectCenter sharedJKConnectCenter] submitSatisfactionWithDict:dict Block:^(id  _Nullable result) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                if (weakSelf.returnMessageBlock) { weakSelf.returnMessageBlock(name);
//                }
                weakSelf.navigationController.navigationBarHidden = NO;
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            });
        }];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.sectionOneArr.count;
    }else if (section == 1) {
        return self.sectionTwoArr.count - 1;
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifer = @"cell";
    JKStatisfactionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[JKStatisfactionCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    
    if (indexPath.section == 0 || indexPath.section == 1) {
        self.satisTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        self.satisTableView.separatorColor = UIColorFromRGB(0xcccccc);
    }else {
        self.satisTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0 || indexPath.section == 1) {
        NSArray *array = indexPath.section == 0 ?self.sectionOneArr:self.sectionTwoArr;
        cell.model = array[indexPath.row];
    }else{
        cell.model = self.sectionTwoArr.lastObject;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray * array = indexPath.section == 0?self.sectionOneArr:self.sectionTwoArr;
    JKSatisfactionModel * model = array[indexPath.row];
    if (!model.canClick) {
        return;
    }
    for (int i = 0; i < array.count; i ++) {
        JKSatisfactionModel * model = array[i];
        model.showSelect = NO;
        if (i == indexPath.row) {
            model.showSelect = YES;
        }
    }
    [self.satisTableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 2 ? 150:44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0?50:30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] init];
    if (section == 0) {
        UILabel * content = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 30, 50)];
        content.text = self.content;
        content.numberOfLines = 0;
        content.lineBreakMode = NSLineBreakByWordWrapping;
        if ([[UIDevice currentDevice].systemVersion doubleValue] < 9.0) {
            content.font =  [UIFont systemFontOfSize:14];
        }else {
            content.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        }
        [view addSubview:content];
    }
    return view;
}
-(UITableView *)satisTableView {
    if (_satisTableView == nil) {
        _satisTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _satisTableView.delegate = self;
        _satisTableView.dataSource = self;
//        if(@available(iOS 11.0, *)) {
//            _satisTableView.estimatedRowHeight =0;
//            _satisTableView.estimatedSectionHeaderHeight =0;
//            _satisTableView.estimatedSectionFooterHeight =0;
//        }
    }
    return _satisTableView;
}
@end
