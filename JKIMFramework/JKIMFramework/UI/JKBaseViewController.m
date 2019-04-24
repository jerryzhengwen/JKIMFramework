//
//  JKBaseViewController.m
//  JKIMSDKProject
//
//  Created by Jerry on 2019/4/19.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKBaseViewController.h"
#import "JKDialogueHeader.h"
#import "JKSatisfactionViewController.h"
@interface JKBaseViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UIView *navigation;

@property(nonatomic, strong)UIButton *backButton;


@end

@implementation JKBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavigation];
    [self initGestureWithTableView];
}
- (void)creatNavigation{
    [self.view addSubview:self.navigation];
    UIColor *navigationBarColor = [JKDialogueSetting sharedSetting].navigationBarColor ? [JKDialogueSetting sharedSetting].navigationBarColor : [UIColor colorWithRed:28 / 255.0 green:158 / 255.0 blue:211 / 255.0 alpha:1];
    self.navigation.backgroundColor = navigationBarColor;
    
    [self.navigation addSubview:self.titleLabel];
    
    self.navigation.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kStatusBarAndNavigationBarHeight);
    self.titleLabel.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 25);
   
    CGPoint center = self.titleLabel.center;
    center.x = self.navigation.center.x;
    center.y = iPhoneXR || iPhoneX ? self.navigation.center.y + 20 : self.navigation.center.y + 10;
    self.titleLabel.center = center;
    
}

/** 设置返回按钮*/
- (void)createBackButton{
    [self.navigation addSubview:self.backButton];
    self.backButton.frame = CGRectMake(25, 0, 50, 21);
    
    CGPoint backButtonCenter = self.backButton.center;
    backButtonCenter.y = self.titleLabel.center.y;
    self.backButton.center = backButtonCenter;
}
-(NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(void)initGestureWithTableView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addToucheEvent:)];
    [self.tableView addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
}


#pragma -
#pragma mark - getter

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (UIView *)navigation{
    if (_navigation == nil) {
        _navigation = [[UIView alloc]init];
    }
    return _navigation;
}


- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [JKDialogueSetting sharedSetting].navigationBarTitleFont ? [JKDialogueSetting sharedSetting].navigationBarTitleFont : [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [JKDialogueSetting sharedSetting].navigationBarTitleColor ? [JKDialogueSetting sharedSetting].navigationBarTitleColor : [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"JK_Dialogue".JK_localString;
    }
    return _titleLabel;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_backButton setTitle:@"JK_Back".JK_localString forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
    
}


#pragma -
#pragma mark - delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifer = @"identifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


#pragma -
#pragma mark - action

- (void)backAction:(id)sender{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)addToucheEvent:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}


@end
