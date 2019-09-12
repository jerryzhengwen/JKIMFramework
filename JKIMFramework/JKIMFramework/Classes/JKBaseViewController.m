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
    [self initRefreshQ];
    [self creatNavigation];
    [self initGestureWithTableView];
}
-(void)initRefreshQ {
    _refreshQ = [[NSOperationQueue alloc] init];
    _refreshQ.name = @"refreshData";
    _refreshQ.maxConcurrentOperationCount = 1;
}
- (void)creatNavigation{
    [self.view addSubview:self.navigation];
    UIColor *navigationBarColor = [UIColor whiteColor];
    self.navigation.backgroundColor = navigationBarColor;
    
    [self.navigation addSubview:self.titleLabel];
    
    self.navigation.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kStatusBarAndNavigationBarHeight);
    self.titleLabel.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 25);
    
    CGPoint center = self.titleLabel.center;
    center.x = self.navigation.center.x;
    center.y = iPhoneXR || iPhoneX ? self.navigation.center.y + 20 : self.navigation.center.y + 10;
    self.titleLabel.center = center;
}
-(void)createCenterImageView {
    NSString *filePatch =  [[JKBundleTool initBundlePathWithImage] stringByAppendingPathComponent:@"jk_customer"];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:filePatch]];
    CGRect rect = self.navigation.frame;
    imageView.frame = CGRectMake(CGRectGetMidX(rect)-20, CGRectGetMaxY(rect) - 20, 40, 40);
    [self.view addSubview:imageView];
}
-(UIButton *)endDialogBtn {
    if (_endDialogBtn == nil) {
        _endDialogBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_endDialogBtn setTitle:@"结束会话" forState:UIControlStateNormal];
        if ([[UIDevice currentDevice].systemVersion doubleValue] < 9.0) {
            _endDialogBtn.titleLabel.font =  [UIFont systemFontOfSize:16];
        }else {
            _endDialogBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        }
        [_endDialogBtn setTitleColor:JKDefaultColor forState:UIControlStateNormal];
    }
    return _endDialogBtn;
}
-(void)createRightButton {
    UIView *lineView = [UIView createBackView];
    lineView.backgroundColor = UIColorFromRGB(0xDADADE);
    lineView.frame = CGRectMake(0, CGRectGetMaxY(self.navigation.frame) -1, [UIScreen mainScreen].bounds.size.width, 1);
    [self.navigation addSubview:lineView];
    [self.navigation addSubview:self.endDialogBtn];
    self.endDialogBtn.frame = CGRectMake(CGRectGetMaxX(self.navigation.frame)-80, CGRectGetMaxY(self.navigation.frame)-32, 64, 22);
    [self.endDialogBtn addTarget:self action:@selector(endDialogeClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)endDialogeClick {
//    [[JKConnectCenter sharedJKConnectCenter] getEndChatBlock:^(BOOL satisFaction) {
//        if (satisFaction) {
//            
//        }else {
//            
//        }
//        
//    }];
}
/** 设置返回按钮*/
- (void)createBackButton{
    [self.navigation addSubview:self.backButton];
    self.backButton.frame = CGRectMake(16, 0, 50, 21);
    CGPoint backButtonCenter = self.backButton.center;
    backButtonCenter.y = self.titleLabel.center.y;
    self.backButton.center = backButtonCenter;
    self.backButton.imageEdgeInsets = UIEdgeInsetsMake(4, 0, 4, 42);
}
-(NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)dataFrameArray {
    if (_dataFrameArray == nil) {
        _dataFrameArray = [[NSMutableArray alloc] init];
    }
    return _dataFrameArray;
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
        if(@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight =0;
            _tableView.estimatedSectionHeaderHeight =0;
            _tableView.estimatedSectionFooterHeight =0;
        }
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
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *filePatch = [[JKBundleTool initBundlePathWithImage] stringByAppendingPathComponent:@"jk_return"];
        [_backButton setImage:[UIImage imageWithContentsOfFile:filePatch] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
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
    return self.dataFrameArray.count;
}


#pragma -
#pragma mark - action

- (void)backAction{
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
