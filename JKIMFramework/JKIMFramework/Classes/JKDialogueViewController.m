//
//  JKDialogueViewController.m
//  JKIMSDKProject
//
//  Created by zzx on 2019/3/12.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKDialogueViewController.h"
#import "JKFloatBallManager.h"
#import "JKConnectCenter.h"
#import "JYFaceView.h"
#import "JKDialogueSetting.h"
#import "JKDialogeContentManager.h"
#import "JK_DialogeContent+CoreDataClass.h"
#import "UIView+JKFloatFrame.h"
#import "JKDialogModel.h"
#import "JKDialogeViewCell.h"
#import "JKRichTextStatue.h"
#import "JKBundleTool.h"
#import "RegexKitLite.h"
#define iPhoneX ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812)
#define iPhoneXR ([UIScreen mainScreen].bounds.size.width == 414 && [UIScreen mainScreen].bounds.size.height == 896)
#define kStatusBarAndNavigationBarHeight (iPhoneX || iPhoneXR ? 88.f : 64.f)

@interface JKDialogueViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,ConnectCenterDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIView *bottomView;

@property(nonatomic, strong)UIView *navigation;

@property(nonatomic, strong)UILabel *titleLabel;

@property(nonatomic, strong)UIButton *backButton;

@property (nonatomic,assign,getter=isPush)BOOL pushToController;

@property (nonatomic, strong)UITextView *textView;

@property (nonatomic,strong)JYFaceView *faceView;

@property (nonatomic, strong)UIButton *sendButton;
///表情按钮
@property (nonatomic, strong)UIButton *faceButton;
@property(nonatomic, strong)NSMutableArray <JKDialogModel *>*dataArray;

@property (nonatomic,assign,getter=isRobotOn)BOOL robotOn;

@property (nonatomic,copy) NSString *customerName;
@end

@implementation JKDialogueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
    [self creatNavigation];
}
-(JYFaceView *)faceView {
    if (_faceView == nil) {
        _faceView = [[JYFaceView alloc] initWithFrame:CGRectMake(0, self.bottomView.bottom, self.view.width, 145)];
        _faceView.hidden = YES;
    }
    return _faceView;
}
- (void)creatUI{
    
     self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:244/255.0 alpha:1];
    self.dataArray = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self bottomViewInitialLayout];
    [self.bottomView addSubview:self.textView];
    self.textView.frame = CGRectMake(40, 10, [UIScreen mainScreen].bounds.size.width - 40 - 90, BottomToolHeight - 10 * 2);
    [self.bottomView addSubview:self.sendButton];

    [self.bottomView addSubview:self.faceButton];
    self.sendButton.frame = CGRectMake(self.view.right - 40 , 0, 30, 30);
    CGPoint sendBtnCenter = self.sendButton.center;
    sendBtnCenter.y = self.textView.center.y;
    self.sendButton.center = sendBtnCenter;
    self.faceButton.frame = CGRectMake(self.textView.right +10, self.sendButton.top, 30, 30);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [JKConnectCenter sharedJKConnectCenter].delegate = self;
    
    [self loadHistoryData];
    
}

- (void)loadHistoryData{
    
    [[JKDialogeContentManager sharedInstance] selectEntity:[NSArray array] ascending:NO filterString:nil success:^(NSArray * _Nonnull results) {
        
        for (int i = 0; i < results.count; i++) {
            JK_DialogeContent *dataModel = results[i];
            JKDialogModel *dataDialogModel = [JKDialogModel new];
            dataDialogModel.imageHeight = dataModel.imageHeight;
            dataDialogModel.imageWidth  = dataModel.imageWidth;
            dataDialogModel.messageType = dataModel.messageType;
            dataDialogModel.message     = dataModel.message;
            dataDialogModel.iconName    = dataModel.iconName;
            dataDialogModel.roomId      = dataModel.roomId;
            dataDialogModel.chatId      = dataModel.chatId;
            dataDialogModel.iconUrl     = dataModel.iconUrl;
            dataDialogModel.time        = dataModel.time;
            NSNumber *number = [NSNumber numberWithInt:dataModel.whoSend];
            
            dataDialogModel.whoSend     = number.intValue;
            dataDialogModel.isRichText  = dataModel.isRichText;
            
            [self.dataArray addObject:dataDialogModel];
        }
        
        [self.tableView reloadData];
        
    } fail:^(NSError * _Nonnull error) {
        NSLog(@"失败");
    }];
    
    [self.view addSubview:self.faceView];
    __weak JKDialogueViewController *weakSelf = self;
    self.faceView.clickBlock = ^(NSString * faceString) {
        weakSelf.textView.text = [NSString stringWithFormat:@"%@%@",weakSelf.textView.text,faceString];
    };
}

- (void)creatNavigation{
    [self.view addSubview:self.navigation];
    UIColor *navigationBarColor = [JKDialogueSetting sharedSetting].navigationBarColor ? [JKDialogueSetting sharedSetting].navigationBarColor : [UIColor colorWithRed:28 / 255.0 green:158 / 255.0 blue:211 / 255.0 alpha:1];
    self.navigation.backgroundColor = navigationBarColor;
    
    [self.navigation addSubview:self.titleLabel];
    [self.navigation addSubview:self.backButton];
    
    self.navigation.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kStatusBarAndNavigationBarHeight);
    self.titleLabel.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 25);
    self.backButton.frame = CGRectMake(25, 0, 33, 21);
    CGPoint center = self.titleLabel.center;
    center.x = self.navigation.center.x;
    center.y = iPhoneXR || iPhoneX ? self.navigation.center.y + 20 : self.navigation.center.y + 10;
    self.titleLabel.center = center;
    
    CGPoint backButtonCenter = self.backButton.center;
    backButtonCenter.y = self.titleLabel.center.y;
    self.backButton.center = backButtonCenter;
}



- (void)backAction:(id)sender{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (NSMutableDictionary *)sendDataMessageWithModel:(JKDialogModel *)model{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:model.roomId ? model.roomId : @"" forKey:@"roomId"];
    [dict setObject:model.chatId ? model.chatId : @"" forKey:@"chatId"];
    [dict setObject:model.iconName ? model.iconName : @"" forKey:@"iconName"];
    [dict setObject:model.iconUrl ? model.iconUrl : @"" forKey:@"iconUrl"];
    NSNumber *height = [NSNumber numberWithFloat:model.imageHeight];
    [dict setObject:height forKey:@"imageHeight"];
    NSNumber *width = [NSNumber numberWithFloat:model.imageWidth];
    [dict setObject:width forKey:@"imageWidth"];
    [dict setObject:model.message ? model.message : @"" forKey:@"message"];
    
    NSNumber *messageT = [NSNumber numberWithInteger:model.messageType];
    [dict setObject:messageT forKey:@"messageType"];
    
    [dict setObject:[self jk_getTimestamp] forKey:@"time"];
    
    NSNumber *wSend = [NSNumber numberWithInteger:model.whoSend];
    [dict setObject:wSend forKey:@"whoSend"];
    [dict setObject:@(model.isRichText) forKey:@"isRichText"];
    
    return dict;
}

- (void)sendMessage:(id)sender{
    if (self.textView.text.length < 1) {
        return;
    }
    
    JKDialogModel * model = [JKDialogModel alloc];

    model.isRichText = NO;
    
    model.message = self.textView.text;
    
    model.time = [self jk_getTimestamp];
    
    NSMutableDictionary *dict = [self sendDataMessageWithModel:model];
    
    __weak typeof(self) weakSelf = self;
    [[JKDialogeContentManager sharedInstance] insertNewEntity:dict success:^{
        [weakSelf.dataArray addObject:model];
        [weakSelf tableViewMoveToLastPath];
        NSLog(@"加入成功");
    } fail:^(NSError * _Nonnull error) {
        NSLog(@"加入失败");
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        BOOL isRobotON = [JKConnectCenter sharedJKConnectCenter].isRobotOn;
        
        if ([model.message isEqualToString:@"转人工"] && isRobotON == YES) {
            [self sendZhuanRenGong];
        }else{
            [self sendAutoReplayWithString:@"我无法回答您的问题，请您点击这里，转向人工客服咨询。"];
        }
    });
    
    
    
    self.textView.text = @"";
}
-(void)sendAutoReplayWithString:(NSString *)message {
    JKDialogModel * autoModel = [JKDialogModel alloc];
    autoModel.isRichText = YES;
    autoModel.message = message;
    autoModel.time = [self jk_getTimestamp];
    autoModel.whoSend = JK_Customer;
    
    
    
    NSMutableDictionary *dict = [self sendDataMessageWithModel:autoModel];
    
    __weak typeof(self) weakSelf = self;
    [[JKDialogeContentManager sharedInstance] insertNewEntity:dict success:^{
        [weakSelf.dataArray addObject:autoModel];
        [weakSelf tableViewMoveToLastPath];
        NSLog(@"加入成功");
    } fail:^(NSError * _Nonnull error) {
        NSLog(@"加入失败");
    }];
    
    
}
/**
 获取时间戳

 @return 当前的时间戳
 */
-(NSString *)jk_getTimestamp {
    NSDate *now = [NSDate date];
    NSTimeInterval tempTime = [now timeIntervalSince1970]*1000;
    NSInteger timestamp = [[NSString stringWithFormat:@"%.f",tempTime] doubleValue];
    return [NSString stringWithFormat:@"%zd",timestamp];
}

#pragma -
#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"JKDialogueViewControllerIdentifier";
    JKDialogeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[JKDialogeViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    __weak JKDialogueViewController * weakSelf = self;
    cell.clickCustomer = ^(NSString * customeName) {
        if (weakSelf.customerName.length) {
         // 接入的动作，以及提示
        }else {
            weakSelf.customerName = [customeName substringFromIndex:1];
            int visitorCustomer = customeName.intValue;
            JKMessage *message = [JKMessage new];
            message.content = [NSString stringWithFormat:@"%d",visitorCustomer];
            [[JKConnectCenter sharedJKConnectCenter] sendRobotMessage:message robotMessageBlock:^(JKMessage *message, int count) {}];
        }
        [weakSelf sendAutoReplayWithString:[NSString stringWithFormat:@"正在为您接入客服%@中，请稍后！",weakSelf.customerName]];
    };
    cell.richText = ^{
        if (weakSelf.customerName.length) {
            [weakSelf sendAutoReplayWithString:[NSString stringWithFormat:@"正在为您接入客服%@中，请稍后！",weakSelf.customerName]];
        }else {
            [weakSelf sendZhuanRenGong];
        }
    };
    cell.skipBlock = ^(NSString * clickText) {
        [weakSelf skipOtherWithRegular:clickText];
    };
    return cell;
}
-(void)skipOtherWithRegular:(NSString *)clickText {
    NSArray *urlArray =  [clickText componentsMatchedByRegex:JK_URlREGULAR];
    NSArray *phoneArray = [clickText componentsMatchedByRegex:JK_PHONENUMBERREGLAR];
    if (urlArray.count) {
        NSURL* url = [[NSURL alloc] initWithString:clickText];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
        [[UIApplication sharedApplication ] openURL: url];
        }
    }else if (phoneArray.count){
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",clickText];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if (
        self.faceView.hidden == NO) {
        self.faceView.hidden = YES;
        self.faceButton.selected = NO;
        NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
        NSString *filePatch = [bundlePatch stringByAppendingPathComponent:@"icon_expression"];
        [self.faceButton setImage:[UIImage imageWithContentsOfFile:filePatch] forState:UIControlStateNormal];
        [self bottomViewInitialLayout];
    }
    
}


/**
 下方的view初始位置
 */
- (void)bottomViewInitialLayout{
    if (kStatusBarAndNavigationBarHeight == 88) {
        CGFloat safeSeparation = 24;
        
        self.tableView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - BottomToolHeight - kStatusBarAndNavigationBarHeight - safeSeparation);
        
    }else{
        self.tableView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - BottomToolHeight - kStatusBarAndNavigationBarHeight);
        
    }
    self.bottomView.frame = CGRectMake(0, self.tableView.bottom, [UIScreen mainScreen].bounds.size.width, BottomToolHeight);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = self.dataArray[indexPath.row].imageHeight + 30;
    CGFloat cellBottom = 10;
    return  height < 84? 84 + cellBottom : height + cellBottom;
}

/** 滚动到最后一行*/
-(void)tableViewMoveToLastPath {
    @try {
        if (self.dataArray.count <= 1) {
            return;
        }
        [self.tableView reloadData];
        // 4.自动滚动表格到最后一行
        NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
        
        [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    @catch (NSException *exception) {
        NSLog(@"-----%@",exception);
    }
    @finally {
        
    }
    
}

#pragma -
#pragma mark - 消息的Delegate
/**
 收到消息
 
 @param message 消息
 */
- (void)didReceiveMessage:(JKMessage *)message{
    
}
/**
 收到新的坐席消息
 
 @param message message
 */
- (void)receiveNewListChat:(JKMessage *)message{
    
}


#pragma mark- 通知方法
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"JKDialogueViewController 释放了");
}

- (void)UIKeyboardWillShowNotification:(NSNotification *)noti {
    self.faceButton.selected = NO;
    NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
    NSString *filePatch =  [bundlePatch stringByAppendingPathComponent:@"icon_expression"];
     [self.faceButton setImage:[UIImage imageWithContentsOfFile:filePatch] forState:UIControlStateNormal];
    
    double duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    NSDictionary *dict = [noti userInfo];
    NSValue *frameValue = [dict valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [frameValue CGRectValue];
    CGFloat height = CGRectGetHeight(rect);
    CGRect rect1 = self.bottomView.frame;
    __weak typeof(self) weakSelf = self;
    rect1.origin.y = [[UIScreen mainScreen] bounds].size.height - height - self.bottomView.frame.size.height;
    CGFloat safeSeparation = 0.0f;
    if (kStatusBarAndNavigationBarHeight == 88) {
        safeSeparation = 24.0f;
    }
    [UIView animateWithDuration:duration animations:^{
        weakSelf.bottomView.frame = rect1;
        weakSelf.tableView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight, [UIScreen mainScreen].bounds.size.width, CGRectGetMinY(weakSelf.bottomView.frame) - kStatusBarAndNavigationBarHeight);
    }];
    
    [self tableViewMoveToLastPath];
}


- (void)keyBoardWillHidden:(NSNotification *)noti {
    double duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    __weak typeof(self) weakSelf = self;
    CGFloat safeSeparation = 0.0f;
    if (kStatusBarAndNavigationBarHeight == 88) {
        safeSeparation = 24.0f;
    }
    [UIView performWithoutAnimation:^{
        self.tableView.size = CGSizeMake( [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - BottomToolHeight - kStatusBarAndNavigationBarHeight - safeSeparation);
    }];
    
    if (self.faceButton.selected) {
        [UIView performWithoutAnimation:^{
            self.tableView.size = CGSizeMake( [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - BottomToolHeight - kStatusBarAndNavigationBarHeight - safeSeparation);
            self.bottomView.frame = CGRectMake(self.bottomView.left, self.tableView.bottom, self.tableView.width, self.bottomView.height);
        }];
    }else {
        [UIView animateWithDuration:duration animations:^{
        
        weakSelf.bottomView.frame = CGRectMake(0, weakSelf.tableView.bottom, [UIScreen mainScreen].bounds.size.width, BottomToolHeight);
        }];
    }
}

/**
 发送转人工
 */
- (void)sendZhuanRenGong{
    JKMessage *message = [JKMessage new];
    message.content = @"转人工";
    [[JKConnectCenter sharedJKConnectCenter] sendRobotMessage:message robotMessageBlock:^(JKMessage *messageData, int count) {
        JKDialogModel * autoModel = [[JKDialogModel alloc] init];
        
        autoModel.isRichText = YES;
        autoModel.message = messageData.content;
        autoModel.whoSend = JK_Customer;
        autoModel.imageWidth = [UIScreen mainScreen].bounds.size.width - 170;
        autoModel.time = [self jk_getTimestamp];
        autoModel.customerNumber = count;
        
        NSMutableDictionary *dict = [self sendDataMessageWithModel:autoModel];
        
        __weak typeof(self) weakSelf = self;
        [[JKDialogeContentManager sharedInstance] insertNewEntity:dict success:^{
            [weakSelf.dataArray addObject:autoModel];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
            
            NSLog(@"加入成功");
        } fail:^(NSError * _Nonnull error) {
            NSLog(@"加入失败");
        }];
        
    }];
}


#pragma -
#pragma mark - lazy

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        _titleLabel.text = @"对话";
    }
    return _titleLabel;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
    
}

- (UIView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = self.view.backgroundColor;
        _bottomView.layer.borderWidth = 0.5;
        _bottomView.layer.borderColor = [[UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1.0] CGColor];
    }
    return _bottomView;
}

- (UITextView *)textView{
    if (_textView == nil) {
        _textView = [[UITextView alloc]init];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.returnKeyType = UIReturnKeyDefault;
        _textView.keyboardType = UIKeyboardTypeDefault;
        _textView.textColor = [UIColor blackColor];
        _textView.delegate = self;
        _textView.layer.borderWidth = 0.5;
        _textView.layer.borderColor = [[UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1.0] CGColor];
        _textView.layer.cornerRadius = 7.5;
    }
    return _textView;
}
-(UIButton *)faceButton {
    if (_faceButton == nil) {
        _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
        NSString *filePatch = [bundlePatch stringByAppendingPathComponent:@"icon_expression"];
        [_faceButton setImage:[UIImage imageWithContentsOfFile:filePatch] forState:UIControlStateNormal];
        [_faceButton addTarget:self action:@selector(clickFaceBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceButton;
}
-(void)clickFaceBtn:(UIButton *)button {
    button.selected = !button.isSelected;
    float duration = 0.1;
    if (self.textView.isFirstResponder) {
        [self.textView resignFirstResponder];
        duration = 0.0;
    }
    NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
    NSString *filePatch = @"";
    if (button.selected) {
        self.faceView.hidden = NO;
        filePatch =  [bundlePatch stringByAppendingPathComponent:@"icon_expression_hl"];
        [UIView performWithoutAnimation:^{
            self.tableView.frame = CGRectMake(0, self.tableView.top, self.tableView.width, self.tableView.height - 145);
            self.bottomView.frame = CGRectMake(0, self.tableView.bottom, self.bottomView.width, self.bottomView.height);
        }];
        
        [UIView animateWithDuration:duration animations:^{
            self.faceView.frame = CGRectMake(0, self.bottomView.bottom, self.faceView.width, self.faceView.height);
        }];
    }else {
        filePatch =  [bundlePatch stringByAppendingPathComponent:@"icon_expression"];
        [UIView performWithoutAnimation:^{
            self.tableView.frame = CGRectMake(0, self.tableView.top, self.tableView.width, self.tableView.height + 145);
            self.bottomView.frame = CGRectMake(0, self.tableView.bottom, self.bottomView.width, self.bottomView.height);
        }];
        
        [UIView animateWithDuration:0.1 animations:^{
            self.faceView.frame = CGRectMake(0, self.bottomView.bottom, self.faceView.width, self.faceView.height);
            self.faceView.hidden = YES;
        }];
    }
    [button setImage:[UIImage imageWithContentsOfFile:filePatch] forState:UIControlStateNormal];
}
- (UIButton *)sendButton{
    if (_sendButton == nil) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
        NSString *filePatch = [bundlePatch stringByAppendingPathComponent:@"sendNormal"];
        NSString *sendImage = [bundlePatch stringByAppendingPathComponent:@"sendImage"];
         [_sendButton setImage:[UIImage imageWithContentsOfFile:filePatch] forState:UIControlStateNormal];
        [_sendButton setImage:[UIImage imageWithContentsOfFile:sendImage] forState:UIControlStateHighlighted];
        [_sendButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[JKFloatBallManager shared] hiddenFloatBall];
    
    if (self.navigationController) {
        self.navigationController.navigationBar.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.pushToController = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.isPush == YES) {
        [[JKFloatBallManager shared] hiddenFloatBall];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if (self.isPush == NO) {
        [[JKFloatBallManager shared]removeDialogueVC];
        [[JKFloatBallManager shared] showFloatBall];
    }
}


@end
