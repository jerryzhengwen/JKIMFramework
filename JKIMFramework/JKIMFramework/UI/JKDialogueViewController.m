//
//  JKDialogueViewController.m
//  JKIMSDKProject
//
//  Created by zzx on 2019/3/12.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKDialogueViewController.h"
#import "JKSatisfactionViewController.h"
#import "JKDialogueHeader.h"
#import "NSString+LocalString.h"
#import "JKMessageFrame.h"
#import "JKMessageCell.h"
#import "NSObject+JKCurrentVC.h"
#import "JKIMSendHelp.h"

@interface JKDialogueViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,ConnectCenterDelegate,JKMessageCellDelegate>



@property(nonatomic,strong)UIView *bottomView;

@property(nonatomic, strong)NSString *isPushToController;

@property (nonatomic, strong)UITextView *textView;

@property (nonatomic,strong)JYFaceView *faceView;

@property (nonatomic,strong)JKPluginView *plugInView;

@property (nonatomic,strong)UIButton *moreBtn;

///表情按钮
@property (nonatomic, strong)UIButton *faceButton;

@property(nonatomic, strong)NSMutableArray <JKDialogModel *>*dataArray;
@property(nonatomic, strong)NSMutableArray <JKMessageFrame *>*dataFrameArray;

@property (nonatomic,assign,getter=isRobotOn)BOOL robotOn;

@property (nonatomic,copy) NSString *customerName;

//收到新的消息时的Message
@property(nonatomic, strong)JKMessage *listMessage;
///点赞按钮
@property(nonatomic, strong)UIButton *satisfieButton;

@property (nonatomic,copy)NSString *imageBundlePath;

@end

@implementation JKDialogueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self loadHistoryData];
    [self createBackButton];
}

-(JYFaceView *)faceView {
    if (_faceView == nil) {
        _faceView = [[JYFaceView alloc] initWithFrame:CGRectMake(0, self.bottomView.bottom, self.view.width, 145)];
        _faceView.hidden = YES;
    }
    return _faceView;
}
-(JKPluginView *)plugInView {
    if (_plugInView == nil) {
        _plugInView = [[JKPluginView alloc] initWithFrame:CGRectMake(0, self.bottomView.bottom, self.view.width, 145)];
        _plugInView.hidden = YES;
    }
    return _plugInView;
}
- (void)creatUI{
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    self.dataArray = [NSMutableArray array];
    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.satisfieButton]; 暂时先隐藏
    [self.view addSubview:self.bottomView];
    [self bottomViewInitialLayout];
    [self.bottomView addSubview:self.textView];
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.delegate = self;
    self.textView.frame = CGRectMake(40, 10, [UIScreen mainScreen].bounds.size.width - 40 - 90, BottomToolHeight - 10 * 2);
    [self.bottomView addSubview:self.moreBtn];
    [self.bottomView addSubview:self.faceButton];
    self.moreBtn.frame = CGRectMake(self.view.right - 40 , 0, 30, 30);
    CGPoint sendBtnCenter = self.moreBtn.center;
    sendBtnCenter.y = self.textView.center.y;
    self.moreBtn.center = sendBtnCenter;
    self.faceButton.frame = CGRectMake(self.textView.right +10, self.moreBtn.top, 30, 30);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPath) name:@"MessageImageComplete" object:nil];
    
    [JKConnectCenter sharedJKConnectCenter].delegate = self;
    [self.view addSubview:self.faceView];
    __weak JKDialogueViewController *weakSelf = self;
    self.faceView.clickBlock = ^(NSString * faceString) {
        weakSelf.textView.text = [NSString stringWithFormat:@"%@%@",weakSelf.textView.text,faceString];
    };
    [self.view addSubview:self.plugInView];
    NSMutableArray *plugArray = [NSMutableArray array];
    for (int i = 0; i < 2; i ++) {
        JKPluginModel * model = [[JKPluginModel alloc] init];
        if (i == 0) {
            model.iconUrl = @"jkcamera";
        }else {
            model.iconUrl = @"jkpicture";
        }
        [plugArray addObject:model];
    }
    self.plugInView.plugArray = [NSArray arrayWithArray:plugArray];
    self.plugInView.clickBlock = ^(int number) {
        if (number == 0) {
            [weakSelf cameraAction];
        }else {
            [weakSelf photoAction];
        }
    };
    
    
    self.satisfieButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, self.tableView.bottom - 60, 50, 50);
    self.satisfieButton.hidden = YES;
    
    
}

- (void)loadHistoryData{
    
    
    self.dataArray = [[JKConnectCenter sharedJKConnectCenter]selectEntity:[NSArray array] ascending:NO filterString:nil];
    
    
    NSInteger index = -1;
    for (int i = 0; i < self.dataArray.count; i++) {
        JKMessage *model = self.dataArray[i];
        JKMessageFrame *framModel = [[JKMessageFrame alloc]init];
        JKDialogModel *dialog = [JKDialogModel changeMsgTypeWithJKModel:model];
        dialog.time = model.time;
        framModel.message = dialog;
        if (model.whoSend == JK_SystemMark) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showSatisfacionViewFromid:model];
            });
            index = i;
        }
        
        [self.dataFrameArray addObject:framModel];
    }
    
    if (index >= 0) {
        //评价的信号文字不用显示
        [self.dataArray removeObjectAtIndex:index];
        [self.dataFrameArray removeObjectAtIndex:index];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self tableViewMoveToLastPath];
    });

    
}
- (void)sendMessage{
    if (self.textView.text.length < 1) {
        return;
    }
    
    self.listMessage.messageType = JKMessageWord;
    self.listMessage.msgSendType = JK_SocketMSG;
    self.listMessage.whoSend = JK_Visitor;
    self.listMessage.content = self.textView.text;
    self.listMessage.isRichText = NO;
    
    [JKIMSendHelp sendTextMessageWithMessageModel:self.listMessage completeBlock:^(JKMessageFrame * _Nonnull messageFrame) {
                                      [self.dataFrameArray addObject:messageFrame];
                                      [self tableViewMoveToLastPath];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        BOOL isRobotON = [JKConnectCenter sharedJKConnectCenter].isRobotOn;
        
        if ([self.textView.text isEqualToString:@"转人工"] && isRobotON == YES) {
            [self sendZhuanRenGong];
        } else if (!self.listMessage.chatState){
            [self sendAutoReplayWithString:@"JK_DialogueView_defaultAnswer".JK_localString];
        }
    });
    self.textView.text = @"";
}

-(void)sendAutoReplayWithString:(NSString *)message {
    
    self.listMessage.messageType = JKMessageWord;
    self.listMessage.msgSendType = JK_SocketMSG;
    self.listMessage.whoSend = JK_Roboter;
    self.listMessage.content = message;
    self.listMessage.isRichText = YES;
    
    [JKIMSendHelp sendTextMessageWithMessageModel:self.listMessage completeBlock:^(JKMessageFrame * _Nonnull messageFrame) {
        [self.dataFrameArray addObject:messageFrame];
        [self tableViewMoveToLastPath];
    }];
    
}

#pragma -
#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataFrameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"JKDialogueViewControllerIdentifier";
    JKMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[JKMessageCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell setMessageFrame:self.dataFrameArray[indexPath.row]];
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
        NSString *filePatch = [self.imageBundlePath stringByAppendingPathComponent:@"icon_expression"];
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
    CGFloat height = self.dataFrameArray[indexPath.row].cellHeight;
    return  height;
}



/** 滚动到最后一行*/
-(void)tableViewMoveToLastPath {
    @try {
        if (self.dataFrameArray.count < 1) {
            return;
        }
        [self.tableView reloadData];
        // 4.自动滚动表格到最后一行
        NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.dataFrameArray.count - 1 inSection:0];

        [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    @catch (NSException *exception) {
        NSLog(@"-----%@",exception);
    }
    @finally {
        
    }
}

//刷新数据
- (void)reloadPath{
    if (self.dataFrameArray.count < 1) {
        return;
    }
    [UIView performWithoutAnimation:^{
        [self.tableView reloadData];
    }];
    
}

- (void)cameraAction{
    
    self.isPushToController = @"YES";
    
    [self presentChoseCameraWithCompletionHandler:^(NSData * _Nonnull imageData, UIImage * _Nonnull image) {
        
        [self sendImageWithImageData:imageData image:image];
        
    }];
    
}
- (void)photoAction{
    self.isPushToController = @"YES";
    
    [self presentChosePhotoAlbumWithCompletionHandler:^(NSData * _Nonnull imageData, UIImage * _Nonnull image) {
        [self sendImageWithImageData:imageData image:image];
    }];
}

- (void)sendImageWithImageData:(NSData *)imageData image:(UIImage *)image{
    
    [JKIMSendHelp sendImageMessageWithImageData:imageData image:image completeBlock:^(JKMessageFrame * _Nonnull messageFrame) {
        [self.dataFrameArray addObject:messageFrame];
        [self tableViewMoveToLastPath];
    }];
}

#pragma -
#pragma mark - cell的dDelegate
- (void)cellCompleteLoadImage:(JKMessageCell *)cell{
    [UIView performWithoutAnimation:^{
        @try {
            
            [cell updateConstraints];
        }
        @catch (NSException *exception) {
            NSLog(@"-----%@",exception);
        }
        @finally {
            
        }
    }];
    
}


#pragma -
#pragma mark - 消息的Delegate
/**
 收到消息
 
 @param message 消息
 */
- (void)receiveMessage:(JKMessage *)message{
    dispatch_async(dispatch_get_main_queue(), ^{
        JKDialogModel * autoModel = [message mutableCopy];
        JKMessageFrame *frameModel = [[JKMessageFrame alloc]init];
        if (autoModel.whoSend == JK_SystemMark) {
        [self showSatisfacionViewFromid:autoModel];
            return;
        }
        
        if (!autoModel.chatState) {
            self.customerName = nil;
            self.listMessage.chatState = autoModel.chatState;
            self.titleLabel.text = @"JK_Dialogue".JK_localString;
            self.satisfieButton.hidden = YES;
        }
        autoModel.whoSend = message.whoSend?message.whoSend:JK_Customer;
        autoModel.time = autoModel.time;
        frameModel.message = autoModel;
        [self.dataFrameArray addObject:frameModel];
        [self tableViewMoveToLastPath];
    });
}



- (void)showSatisfacionViewFromid:(JKMessage *)model{
    ///判断如果此时已经有展示框就不弹展示弹框
    UIViewController *vc = [NSObject currentViewController];
    if ([vc isEqual:self]) {
        return;
    }
    [[JKConnectCenter sharedJKConnectCenter]readMessageFromId:model.from];
    JKSatisfactionViewController * view = [[JKSatisfactionViewController alloc]init];
    self.isPushToController = @"YES";
    [self.navigationController pushViewController:view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    view.returnMessageBlock = ^(NSString * _Nonnull message) {
        NSString *value = @"";
        NSArray * array = [model.from componentsSeparatedByString:@"/"];
        if (array.count > 1) {
            NSString *username = [array[1] componentsSeparatedByString:@"@openfire-test"].firstObject;
            value = [username componentsSeparatedByString:@"-"].lastObject;
        }
        message = [NSString stringWithFormat:@"%@%@%@%@",@"JK_SubmitShowTip".JK_localString,value,@"JK_SubmitTip".JK_localString,message];
        
        self.listMessage.messageType = JKMessageWord;
        self.listMessage.msgSendType = JK_SocketMSG;
        self.listMessage.whoSend = JK_SystemMarkShow;
        self.listMessage.content = message;
        self.listMessage.isRichText = NO;
        
        [JKIMSendHelp sendTextMessageWithMessageModel:self.listMessage completeBlock:^(JKMessageFrame * _Nonnull messageFrame) {
            [self.dataFrameArray addObject:messageFrame];
            [self tableViewMoveToLastPath];
        }];
        
    };
}

/**
 收到新的坐席消息
 
 @param message message
 */
-(void)receiveNewListChat:(JKMessage *)message {
    self.listMessage = message;
    if (self.listMessage.chatterName) {
        self.titleLabel.text = self.listMessage.chatterName;
        self.satisfieButton.hidden = NO;
    }
}

#pragma mark- 通知方法
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"JKDialogueViewController 释放了");
}

- (void)UIKeyboardWillShowNotification:(NSNotification *)noti {
    self.faceButton.selected = NO;
    self.moreBtn.selected = NO;
    NSString *filePatch =  [self.imageBundlePath stringByAppendingPathComponent:@"icon_expression"];
    NSString *morePatch =  [self.imageBundlePath stringByAppendingPathComponent:@"jkmorebtn"];
    [self.faceButton setImage:[UIImage imageWithContentsOfFile:filePatch] forState:UIControlStateNormal];
    [self.moreBtn setImage:[UIImage imageWithContentsOfFile:morePatch] forState:UIControlStateNormal];
    self.faceView.frame = CGRectMake(self.faceView.left, self.view.bottom, self.faceView.width, self.faceView.height);
    self.plugInView.frame = CGRectMake(self.plugInView.left, self.view.bottom, self.plugInView.width, self.plugInView.height);
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
    
    if (self.faceButton.selected || self.moreBtn.selected) {
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
    __weak typeof(self) weakSelf = self;
    [[JKConnectCenter sharedJKConnectCenter] sendRobotMessage:message robotMessageBlock:^(JKMessage *messageData, int count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            JKDialogModel * autoModel = [[JKDialogModel alloc] init];
            JKMessageFrame *frameModel = [[JKMessageFrame alloc]init];
            autoModel.isRichText = YES;
            autoModel.content = messageData.content;
            autoModel.whoSend = JK_Roboter;
            autoModel.imageWidth = [UIScreen mainScreen].bounds.size.width - 170;
            autoModel.time = autoModel.time;
            autoModel.customerNumber = count;
            frameModel.message = autoModel;
            [weakSelf.dataFrameArray addObject:frameModel];
            [self tableViewMoveToLastPath];
        });
    }];
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

- (UIButton *)satisfieButton{
    if (_satisfieButton == nil) {
        _satisfieButton = [[UIButton alloc]init];
        NSString *filePatch =  [self.imageBundlePath stringByAppendingPathComponent:@"satisfied"];
        [_satisfieButton setImage:[UIImage imageWithContentsOfFile:filePatch] forState:UIControlStateNormal];
    }
    return _satisfieButton;
}

- (NSString *)imageBundlePath{
    if (_imageBundlePath == nil) {
        _imageBundlePath =  [JKBundleTool initBundlePathWithImage];
    }
    return _imageBundlePath;
}


-(UIButton *)faceButton {
    if (_faceButton == nil) {
        _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *filePatch = [self.imageBundlePath stringByAppendingPathComponent:@"icon_expression"];
        [_faceButton setImage:[UIImage imageWithContentsOfFile:filePatch] forState:UIControlStateNormal];
        [_faceButton addTarget:self action:@selector(clickFaceBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceButton;
}
-(void)plugInBtn:(UIButton *)button {
    button.selected = !button.isSelected;
    float duration = 0.1;
    if (self.textView.isFirstResponder) {
        [self.textView resignFirstResponder];
        duration = 0.0;
    }
    if (self.faceButton.selected) {
        self.faceButton.selected = !self.faceButton.selected;
     NSString *facePath = [self.imageBundlePath stringByAppendingPathComponent:@"icon_expression"];
    [self.faceButton setImage:[UIImage imageWithContentsOfFile:facePath] forState:UIControlStateNormal];
        self.tableView.frame = CGRectMake(0, self.tableView.top, self.tableView.width, self.tableView.height + 145);
        self.bottomView.frame = CGRectMake(0, self.tableView.bottom, self.bottomView.width, self.bottomView.height);
        self.faceView.frame = CGRectMake(self.faceView.top, self.bottomView.bottom, self.faceView.width, self.faceView.height);
    }
    NSString *filePatch = @"";
    if (button.selected) {
        self.plugInView.hidden = NO;
        filePatch =  [self.imageBundlePath stringByAppendingPathComponent:@"jkmoreclick"];
        [UIView performWithoutAnimation:^{
            self.tableView.frame = CGRectMake(0, self.tableView.top, self.tableView.width, self.tableView.height - 145);
            self.bottomView.frame = CGRectMake(0, self.tableView.bottom, self.bottomView.width, self.bottomView.height);
        }];
        
        [UIView animateWithDuration:duration animations:^{
            self.plugInView.frame = CGRectMake(0, self.bottomView.bottom, self.plugInView.width, self.plugInView.height);
        }];
    }else {
        filePatch =  [self.imageBundlePath stringByAppendingPathComponent:@"jkmorebtn"];
        [UIView performWithoutAnimation:^{
            self.tableView.frame = CGRectMake(0, self.tableView.top, self.tableView.width, self.tableView.height + 145);
            self.bottomView.frame = CGRectMake(0, self.tableView.bottom, self.bottomView.width, self.bottomView.height);
        }];
        
        [UIView animateWithDuration:0.1 animations:^{
            self.plugInView.frame = CGRectMake(0, self.bottomView.bottom, self.plugInView.width, self.plugInView.height);
            self.plugInView.hidden = YES;
        }];
    }
    [button setImage:[UIImage imageWithContentsOfFile:filePatch] forState:UIControlStateNormal];
}
-(void)clickFaceBtn:(UIButton *)button {
    button.selected = !button.isSelected;
    float duration = 0.1;
    if (self.textView.isFirstResponder) {
        [self.textView resignFirstResponder];
        duration = 0.0;
    }
    if (self.moreBtn.selected) {
        self.moreBtn.selected = !self.moreBtn.selected;
        NSString *morePath = [self.imageBundlePath stringByAppendingPathComponent:@"jkmorebtn"];
        [self.moreBtn setImage:[UIImage imageWithContentsOfFile:morePath] forState:UIControlStateNormal];
        self.tableView.frame = CGRectMake(0, self.tableView.top, self.tableView.width, self.tableView.height + 145);
        self.bottomView.frame = CGRectMake(0, self.tableView.bottom, self.bottomView.width, self.bottomView.height);
        self.plugInView.frame = CGRectMake(0, self.bottomView.bottom, self.plugInView.width, self.plugInView.height);
    }
    NSString *filePatch = @"";
    if (button.selected) {
        self.faceView.hidden = NO;
        filePatch =  [self.imageBundlePath stringByAppendingPathComponent:@"icon_expression_hl"];
        [UIView performWithoutAnimation:^{
            self.tableView.frame = CGRectMake(0, self.tableView.top, self.tableView.width, self.tableView.height - 145);
            self.bottomView.frame = CGRectMake(0, self.tableView.bottom, self.bottomView.width, self.bottomView.height);
        }];
        
        [UIView animateWithDuration:duration animations:^{
            self.faceView.frame = CGRectMake(0, self.bottomView.bottom, self.faceView.width, self.faceView.height);
        }];
    }else {
        filePatch =  [self.imageBundlePath stringByAppendingPathComponent:@"icon_expression"];
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
-(UIButton *)moreBtn {
    if (_moreBtn == nil) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *filePatch = [self.imageBundlePath stringByAppendingPathComponent:@"jkmorebtn"];
        NSString *sendImage = [self.imageBundlePath stringByAppendingPathComponent:@"jkmoreclick"];
        [_moreBtn setImage:[UIImage imageWithContentsOfFile:filePatch] forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage imageWithContentsOfFile:sendImage] forState:UIControlStateHighlighted];
        [_moreBtn addTarget:self action:@selector(plugInBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[JKFloatBallManager shared] hiddenFloatBall];
    
    self.isPushToController = @"NO";
    if (self.navigationController) {
        self.navigationController.navigationBar.hidden = YES;
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[JKConnectCenter sharedJKConnectCenter] readMessageFromId:@""];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.isPushToController isEqualToString:@"YES"]) {
        [[JKFloatBallManager shared] hiddenFloatBall];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if ([self.isPushToController isEqualToString:@"NO"]) {
        [[JKFloatBallManager shared]removeDialogueVC];
        [[JKFloatBallManager shared] showFloatBall];
    }
}
//send键发送
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        //在这里做控制
        [self sendMessage];
        return NO;
    }
    return YES;
}

- (NSMutableArray<JKMessageFrame *> *)dataFrameArray{
    if (_dataFrameArray == nil) {
        _dataFrameArray = [NSMutableArray array];
    }
    return _dataFrameArray;
}

- (JKMessage *)listMessage{
    if (_listMessage == nil) {
        _listMessage = [[JKMessage alloc]init];
    }
    return _listMessage;
}

@end
