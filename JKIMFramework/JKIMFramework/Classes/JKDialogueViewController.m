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
#import "JKMessageFrame.h"
#import "JKMessageCell.h"
#import "JKWebViewCell.h"
#import "NSObject+JKCurrentVC.h"
#import "JKIMSendHelp.h"
#import "JKConnectCenter.h"
#import "RegexKitLite.h"
#import "MJRefresh.h"
@interface JKDialogueViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,ConnectCenterDelegate,JKMessageCellDelegate>

/** 获取图片资源路径 */
//@property (nonatomic,copy)NSString *imageBundlePath;

@property(nonatomic,strong)UIView *bottomView;

//@property(nonatomic, strong)NSString *isPushToController;

@property (nonatomic, strong)UITextView *textView;

@property (nonatomic,strong)JYFaceView *faceView;

@property (nonatomic,strong)JKPluginView *plugInView;

@property (nonatomic,strong)UIButton *moreBtn;
///表情按钮
@property (nonatomic, strong)UIButton *faceButton;

@property (nonatomic,assign,getter=isRobotOn)BOOL robotOn;

@property (nonatomic,copy) NSString *customerName;

//收到新的消息时的Message
@property(nonatomic, strong)JKMessage *listMessage;
///点赞按钮
//@property(nonatomic, strong)UIButton *satisfieButton;
@property(nonatomic,assign) BOOL isLoadHistory;
@end

@implementation JKDialogueViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [[JKConnectCenter sharedJKConnectCenter] checkoutInitCompleteBlock:^(BOOL isComplete) {
    }];
    [self creatUI];
    [self createBackButton];
    [self.view addSubview:self.assoiateView];
    __weak JKDialogueViewController *weakSelf = self;
    self.assoiateView.hotMsgBlock = ^(NSString * _Nonnull question) {
        [weakSelf showHotMsgQuestion:question];
    };
    [self createRightButton];
    [self createCenterImageView];
    MJRefreshNormalHeader * refresh = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadHistoryData];
    }];
    self.tableView.mj_header = refresh;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reneedInit) name:UIApplicationDidBecomeActiveNotification object:nil];
}
-(void)reneedInit {
    [[JKConnectCenter sharedJKConnectCenter] checkoutInitCompleteBlock:^(BOOL isComplete) {
    }];
}
-(void)endDialogeClick {
    __weak JKDialogueViewController *weakSelf = self;
    [[JKConnectCenter sharedJKConnectCenter] getEndChatBlock:^(BOOL satisFaction) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (satisFaction) { //跳转满意度界面
                [weakSelf showSatisfacionViewFromid:[[JKMessage alloc]init]];
            }else { //关闭当前界面
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        });
    }];
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
        _plugInView = [[JKPluginView alloc] initWithFrame:CGRectMake(0, self.bottomView.bottom, self.view.width, 109)];
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
    self.textView.frame = CGRectMake(10, 11, [UIScreen mainScreen].bounds.size.width - 84, 32);
//    [self.bottomView addSubview:self.moreBtn];
//    [self.bottomView addSubview:self.faceButton];
    self.moreBtn.frame = CGRectMake(self.view.right - 32 , 0, 22, 22);
    CGPoint sendBtnCenter = self.moreBtn.center;
    sendBtnCenter.y = self.textView.center.y;
    self.moreBtn.center = sendBtnCenter;
    self.faceButton.frame = CGRectMake(self.view.right - 64, self.moreBtn.top, 22, 22);
    
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
}

- (void)loadHistoryData{
    NSLog(@"---%@",[JKConnectCenter sharedJKConnectCenter].chat_id);
    if (self.isLoadHistory == NO) {
        self.isLoadHistory = YES;
    }else {
        return;
    }
    NSMutableArray *historyArr = [[JKConnectCenter sharedJKConnectCenter]selectEntity:[NSArray array] ascending:NO filterString:nil];
    [self.tableView.mj_header endRefreshing];
    [historyArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JKMessage *historyModel = historyArr[idx];
        for (JKMessageFrame *frameModel in self.dataArray) {
            JKMessage * model =frameModel.message;
            if ([historyModel.messageId isEqualToString:model.messageId]) {
                [historyArr removeObject:historyModel];
            }
        }
    }];
    for (int i = 0; i < historyArr.count; i++) {
        JKMessage *model = historyArr[i];
        JKMessageFrame *framModel = [[JKMessageFrame alloc]init];
        JKDialogModel *dialog = [JKDialogModel changeMsgTypeWithJKModel:model];
        dialog.time = model.time;
        framModel.message = dialog;
        if (model.whoSend != JK_SystemMark) {
            framModel = [self jisuanMessageFrame:framModel];
            if (model.messageType == JKMessageFAQImageText || model.messageType == JKMessageFAQImage) {
                framModel.cellHeight = 0;
            }
            [self.dataFrameArray insertObject:framModel atIndex:0];
        }
    }
    
//    if (index >= 0) {
//        //评价的信号文字不用显示
//        [self.dataArray removeObjectAtIndex:index];
//        [self.dataFrameArray removeObjectAtIndex:index];
//    }
    [self tableViewMoveToLastPathNeedAnimated:NO];
    
    
}
- (void)sendMessage{
    if (self.textView.text.length < 1) {
        return;
    }
    self.listMessage.messageType = JKMessageWord;
    self.listMessage.msgSendType = JK_SocketMSG;
    self.listMessage.whoSend = JK_Visitor;
    self.listMessage.content = self.textView.text;
    
    [JKIMSendHelp sendTextMessageWithMessageModel:self.listMessage completeBlock:^(JKMessageFrame * _Nonnull messageFrame) {
        messageFrame =  [self jisuanMessageFrame:messageFrame];
        [self.dataFrameArray addObject:messageFrame];
        [self tableViewMoveToLastPathNeedAnimated:YES];
    }];
    
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        //在此判断是发给机器人还是房间
    //        if ((!self.listMessage.to.length) && [self.textView.text isEqualToString:@"转人工"]) {
    //            [self sendZhuanRenGong];
    //        }else if ((!self.listMessage.to.length) && ([JKConnectCenter sharedJKConnectCenter].socketState == JK_SocketConnectOnline)){
    //            [self sendAutoReplayWithString:@"JK_DialogueView_defaultAnswer".JK_localString];
    //        }
    //    });
    self.textView.text = @"";
    self.assoiateView.hidden = YES;
}

-(void)sendAutoReplayWithString:(NSString *)message {
    
    self.listMessage.messageType = JKMessageWord;
    self.listMessage.msgSendType = JK_SocketMSG;
    self.listMessage.whoSend = JK_Roboter;
    self.listMessage.content = message;
    self.listMessage.isRichText = YES;
    
    [JKIMSendHelp sendTextMessageWithMessageModel:self.listMessage completeBlock:^(JKMessageFrame * _Nonnull messageFrame) {
        [self.dataFrameArray addObject:messageFrame];
        [self tableViewMoveToLastPathNeedAnimated:YES];
    }];
    
}
-(void)showHotMsgQuestion:(NSString *)question {
    self.textView.text = question;
    [self sendMessage];
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
    __weak JKDialogueViewController * weakSelf = self;
    JKMessageFrame * messageFrame = self.dataFrameArray[indexPath.row];
    if (messageFrame.message.messageType == JKMessageFAQImageText ||messageFrame.message.messageType == JKMessageFAQImage) {
        static NSString *cellIdentifer = @"JKWebViewCell";
        JKWebViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if (!cell) {
            cell = [[JKWebViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifer];
        }
        cell.messageFrame = messageFrame;
        cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.reloadRow = (int)indexPath.row;
        cell.webHeightBlock = ^(int row, BOOL moveToLast) {
            [weakSelf reloadCellWithRow:row MoveToLast:moveToLast];
        };
//        cell.webHeightBlock = ^(int row) {
//            [weakSelf reloadCellWithRow:row];
//        };
//        cell.webHeightBlock = ^{
//            [weakSelf tableViewMoveToLastPathNeedAnimated:YES];
//        };
        return cell;
    }
    if (messageFrame.message.messageType == JKMessageHotMsg) {
        static NSString *hotMsgCell = @"hotMsgCell";
        JKHotMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:hotMsgCell];
        if (!cell) {
            cell = [[JKHotMessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:hotMsgCell];
        }
        cell.hotView.hotMsgBlock = ^(NSString * _Nonnull question) {
            [weakSelf showHotMsgQuestion:question];
        };
        cell.model = messageFrame.message;
        cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString *indentifier = @"JKDialogueViewControllerIdentifier";
    JKMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[JKMessageCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell setMessageFrame:self.dataFrameArray[indexPath.row]];
    cell.clickCustomer = ^(NSString * customeName) {
        if (weakSelf.customerName.length) {
            // 接入的动作，以及提示
        }else {
            //            weakSelf.customerName = [customeName substringFromIndex:1];
            int visitorCustomer = customeName.intValue;
            JKMessage *message = [JKMessage new];
            message.content = [NSString stringWithFormat:@"%d",visitorCustomer];
            [[JKConnectCenter sharedJKConnectCenter] sendRobotMessage:message robotMessageBlock:^(JKMessage *message, int count) {
                if (!count) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        JKDialogModel * autoModel = [[JKDialogModel alloc] init];
                        JKMessageFrame *frameModel = [[JKMessageFrame alloc]init];
                        autoModel.content = message.content;
                        autoModel.whoSend = JK_SystemMarkShow;
                        autoModel.time = autoModel.time;
                        frameModel.message = autoModel;
                        [weakSelf.dataFrameArray addObject:frameModel];
                        [weakSelf tableViewMoveToLastPathNeedAnimated:YES];
                    });
                }else{
                    //再次进行机器人对话
                    [weakSelf showRobotMessage:message count:count];
                };
            }];
        }
    };
    cell.richText = ^{
        if (weakSelf.customerName.length) {
            [weakSelf sendAutoReplayWithString:[NSString stringWithFormat:@"您当前正在和客服%@对话中！",weakSelf.customerName]];
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
    if (self.faceView.hidden == NO) {
        self.faceView.hidden = YES;
        self.faceButton.selected = NO;
        NSString *filePatch = [[JKBundleTool initBundlePathWithImage] stringByAppendingPathComponent:@"icon_expression"];
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
    
    JKMessageFrame * messge = self.dataFrameArray[indexPath.row];
    JKDialogModel * message = messge.message;
    if (message.messageType == JKMessageFAQImage || message.messageType == JKMessageFAQImageText) { //所有的高度都在加10
        return 120 + messge.cellHeight + 10;
    }
    if (message.messageType == JKMessageHotMsg) {
        return message.hotArray.count * 41 + 40; //热点问题在最上面，不加10
    }
    CGFloat height = messge.cellHeight;
    return  height + 10;
}


-(void)reloadCellWithRow:(int)row MoveToLast:(BOOL)moveTo {
    if (moveTo) {
        [self tableViewMoveToLastPathNeedAnimated:YES];
        return;
    }
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
    [self.refreshQ cancelAllOperations];
    [self.refreshQ addOperationWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        });
    }];
}
/** 滚动到最后一行*/
-(void)tableViewMoveToLastPathNeedAnimated:(BOOL)animated {
    @try {
        if (self.dataFrameArray.count < 1) {
            return;
        }
        [self.refreshQ cancelAllOperations];
        [self.refreshQ addOperationWithBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                
                //            CGPoint offset = CGPointMake(0,self.tableView.contentSize.height - self.tableView.frame.size.height);
                //                [self.tableView setContentOffset:offset animated:YES];
                
                // 4.自动滚动表格到最后一行
                NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.dataFrameArray.count - 1 inSection:0];
                
                [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            });
        }];
        
        
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
    [self.refreshQ cancelAllOperations];
    [self.refreshQ addOperationWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView performWithoutAnimation:^{
                [self.tableView reloadData];
            }];
        });
    }];
}

- (void)cameraAction{
    
//    self.isPushToController = @"YES";
    
    [self presentChoseCameraWithCompletionHandler:^(NSData * _Nonnull imageData, UIImage * _Nonnull image) {
        
        [self sendImageWithImageData:imageData image:image];
        
    }];
}
#pragma 相册
- (void)photoAction{
    [self presentChosePhotoAlbumWithCompletionHandler:^(NSData * _Nonnull imageData, UIImage * _Nonnull image) {
        [self sendImageWithImageData:imageData image:image];
    }];
}

- (void)sendImageWithImageData:(NSData *)imageData image:(UIImage *)image{
    
    [JKIMSendHelp sendImageMessageWithImageData:imageData image:image MessageModel:self.listMessage completeBlock:^(JKMessageFrame * _Nonnull messageFrame) {
        [self.dataFrameArray addObject:messageFrame];
        [self tableViewMoveToLastPathNeedAnimated:YES];
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
-(void)receiveRobotRePlay:(JKMessage *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        JKMessageFrame *framModel = [[JKMessageFrame alloc]init];
        JKDialogModel *dialog = [JKDialogModel changeMsgTypeWithJKModel:message];
        JKMessageType type = dialog.messageType;
        framModel.message = dialog;
        framModel = [self jisuanMessageFrame:framModel];
        if (type == JKMessageFAQImageText || type == JKMessageFAQImage) {
            framModel.cellHeight = 0;
            framModel.moveToLast = YES;
        }
        [self.dataFrameArray addObject:framModel];
        [self tableViewMoveToLastPathNeedAnimated:YES];
    });
}
-(void)getRoomHistory:(NSArray<JKMessage *> *)messageArr {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (JKMessage * message in messageArr) {
            JKDialogModel * autoModel = [message mutableCopy];
            JKMessageFrame *frameModel = [[JKMessageFrame alloc] init];
            frameModel.message = autoModel;
            frameModel = [self jisuanMessageFrame:frameModel];
            if (message.messageType == JKMessageFAQImageText || message.messageType == JKMessageFAQImage) {
                frameModel.cellHeight = 0;
            }
            [self.dataFrameArray addObject:frameModel];
        }
        [self reloadPath];
//        [self tableViewMoveToLastPathNeedAnimated:YES];
    });
}
/**
 收到消息
 @param message 消息
 */
- (void)receiveMessage:(JKMessage *)message{
    __weak JKDialogueViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        JKDialogModel * autoModel = [message mutableCopy];
        JKMessageFrame *frameModel = [[JKMessageFrame alloc]init];
        if (autoModel.whoSend == JK_SystemMark) { //在这里判断初始化context_id，以及判断是否弹满意度
            [[JKConnectCenter sharedJKConnectCenter] getEndChatBlock:^(BOOL satisFaction) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (satisFaction) { //跳转满意度界面
                        [weakSelf showSatisfacionViewFromid:autoModel];
                    }
                });
            }];
            //初始化一下context_id;
            [[JKConnectCenter sharedJKConnectCenter] initDialogeWIthSatisFaction];
            return;
        }
        
        if (!autoModel.chatState) {
            self.customerName = nil;
            self.listMessage.chatState = autoModel.chatState;
            self.listMessage.to = @"";
            self.titleLabel.text = @"对话";
        }
        autoModel.whoSend = message.whoSend?message.whoSend:JK_Customer;
        autoModel.time = autoModel.time;
        frameModel.message = autoModel;
        [self.dataFrameArray addObject:frameModel];
        [self tableViewMoveToLastPathNeedAnimated:YES];
    });
}
-(void)receiveHotJKMessage:(JKMessage *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        JKMessageFrame *framModel = [[JKMessageFrame alloc]init];
        JKDialogModel * model = [JKDialogModel changeMsgTypeWithJKModel:message];
        framModel.cellHeight = framModel.message.hotArray.count *41;
        framModel.message = model;
        [self.dataFrameArray addObject:framModel];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self tableViewMoveToLastPathNeedAnimated:YES];
        });
    });
}
- (void)showSatisfacionViewFromid:(JKMessage *)model{
    ///判断如果此时已经有展示框就不弹展示弹框
    UIViewController *vc = [NSObject currentViewController];
    if ([vc isKindOfClass:[JKSatisfactionViewController class]]) {
        return;
    }
    [[JKConnectCenter sharedJKConnectCenter]readMessageFromId:model.from];
    JKSatisfactionViewController * view = [[JKSatisfactionViewController alloc]init];
    view.content = model.content;
    [self.navigationController pushViewController:view animated:YES];
    
//    __weak typeof(self) weakSelf = self;
//    view.returnMessageBlock = ^(NSString * _Nonnull message) {
//        NSString *value = @"";
//        NSArray * array = [model.from componentsSeparatedByString:@"/"];
//        if (array.count > 1) {
//            NSString *username = [array[1] componentsSeparatedByString:@"@openfire-test"].firstObject;
//            value = [username componentsSeparatedByString:@"-"].lastObject;
//        }
//        message = [NSString stringWithFormat:@"%@%@%@%@",@"您给客服",value,@"的评价",message];
//
//        weakSelf.listMessage.messageType = JKMessageWord;
//        weakSelf.listMessage.msgSendType = JK_SocketMSG;
//        weakSelf.listMessage.whoSend = JK_SystemMarkShow;
//        weakSelf.listMessage.content = message;
//        weakSelf.listMessage.isRichText = NO;
//
//        [JKIMSendHelp sendTextMessageWithMessageModel:weakSelf.listMessage completeBlock:^(JKMessageFrame * _Nonnull messageFrame) {
//            messageFrame = [self jisuanMessageFrame:messageFrame];
//            [weakSelf.dataFrameArray addObject:messageFrame];
//            [weakSelf tableViewMoveToLastPathNeedAnimated:YES];
//        }];
//
//    };
}

- (void)showRobotMessage:(JKMessage *)message count:(int)count{
    
    JKDialogModel * autoModel = [[JKDialogModel alloc] init];
    JKMessageFrame *frameModel = [[JKMessageFrame alloc]init];
    autoModel.isRichText = YES;
    autoModel.content = message.content;
    autoModel.whoSend = JK_Roboter;
    autoModel.imageWidth = [UIScreen mainScreen].bounds.size.width - 170;
    autoModel.time = autoModel.time;
    autoModel.customerNumber = count;
    frameModel.message = autoModel;
    [self.dataFrameArray addObject:frameModel];
    [self tableViewMoveToLastPathNeedAnimated:YES];
}

/**
 收到新的坐席消息
 
 @param message message
 */
-(void)receiveNewListChat:(JKMessage *)message {
    self.listMessage = message;
    self.listMessage.to = message.from;
    self.customerName = message.from;
    self.listMessage.from = @"";
    if (self.listMessage.chatterName) {
        self.titleLabel.text = self.listMessage.chatterName;
//        self.satisfieButton.hidden = NO;
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
    NSString *filePatch =  [[JKBundleTool initBundlePathWithImage] stringByAppendingPathComponent:@"icon_expression"];
    NSString *morePatch =  [[JKBundleTool initBundlePathWithImage] stringByAppendingPathComponent:@"jk_morebtn"];
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
        CGFloat assoiateHeight = CGRectGetHeight(weakSelf.assoiateView.frame);
        weakSelf.assoiateView.frame = CGRectMake(rect1.origin.x, rect1.origin.y - assoiateHeight, rect1.size.width, assoiateHeight);
    }];
    
    [self tableViewMoveToLastPathNeedAnimated:NO];
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
    CGFloat assoiateHeight = CGRectGetHeight(weakSelf.assoiateView.frame);
    weakSelf.assoiateView.frame = CGRectMake(0, self.bottomView.top- assoiateHeight, self.view.width, assoiateHeight);
}

/**
 发送转人工
 */
- (void)sendZhuanRenGong{
    __weak typeof(self) weakSelf = self;
    [[JKConnectCenter sharedJKConnectCenter] initDialogeWithBlock:^(NSDictionary *blockDict) {
        BOOL canDialogue = [blockDict[@"result"] boolValue];
        if (canDialogue) {
            JKMessage *message = [JKMessage new];
            message.content = @"转人工";
            [[JKConnectCenter sharedJKConnectCenter] sendRobotMessage:message robotMessageBlock:^(JKMessage *messageData, int count) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //展示机器人消息
                    [weakSelf showRobotMessage:messageData count:count];
                });
            }];
            
            
        }else { //进行错误的提示
            NSString *errorMSG = blockDict[@"result_msg"];
            dispatch_async(dispatch_get_main_queue(), ^{
                JKDialogModel * autoModel = [[JKDialogModel alloc] init];
                JKMessageFrame *frameModel = [[JKMessageFrame alloc]init];
                autoModel.content = errorMSG;
                autoModel.whoSend = JK_SystemMarkShow;
                autoModel.time = autoModel.time;
                frameModel.message = autoModel;
                [weakSelf.dataFrameArray addObject:frameModel];
                [weakSelf tableViewMoveToLastPathNeedAnimated:YES];
            });
        }
    }];
    
}
- (UIView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = UIColorFromRGB(0xFBFBFB);
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

//- (UIButton *)satisfieButton{
//    if (_satisfieButton == nil) {
//        _satisfieButton = [[UIButton alloc]init];
//        NSString *filePatch =  [[JKBundleTool initBundlePathWithImage] stringByAppendingPathComponent:@"satisfied"];
//        [_satisfieButton setImage:[UIImage imageWithContentsOfFile:filePatch] forState:UIControlStateNormal];
//    }
//    return _satisfieButton;
//}


-(UIButton *)faceButton {
    if (_faceButton == nil) {
        _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *filePatch = [[JKBundleTool initBundlePathWithImage] stringByAppendingPathComponent:@"icon_expression"];
        [_faceButton setImage:[UIImage imageWithContentsOfFile:filePatch] forState:UIControlStateNormal];
        [_faceButton addTarget:self action:@selector(clickFaceBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceButton;
}
-(void)plugInBtn:(UIButton *)button {
    //    if (!self.listMessage.to.length) {
    //        return;
    //    }
    
    button.selected = !button.isSelected;
    float duration = 0.1;
    if (self.textView.isFirstResponder) {
        [self.textView resignFirstResponder];
        duration = 0.0;
    }
    if (self.faceButton.selected) {
        self.faceButton.selected = !self.faceButton.selected;
        NSString *facePath = [[JKBundleTool initBundlePathWithImage] stringByAppendingPathComponent:@"icon_expression"];
        [self.faceButton setImage:[UIImage imageWithContentsOfFile:facePath] forState:UIControlStateNormal];
        self.tableView.frame = CGRectMake(0, self.tableView.top, self.tableView.width, self.tableView.height + 145);
        self.bottomView.frame = CGRectMake(0, self.tableView.bottom, self.bottomView.width, self.bottomView.height);
        self.faceView.frame = CGRectMake(self.faceView.top, self.bottomView.bottom, self.faceView.width, self.faceView.height);
    }
    NSString *filePatch = @"";
    if (button.selected) {
        self.plugInView.hidden = NO;
        filePatch =  [[JKBundleTool initBundlePathWithImage] stringByAppendingPathComponent:@"jkmoreclick"];
        [UIView performWithoutAnimation:^{
            self.tableView.frame = CGRectMake(0, self.tableView.top, self.tableView.width, self.tableView.height - 109);
            self.bottomView.frame = CGRectMake(0, self.tableView.bottom, self.bottomView.width, self.bottomView.height);
        }];
        
        [UIView animateWithDuration:duration animations:^{
            self.plugInView.frame = CGRectMake(0, self.bottomView.bottom, self.plugInView.width, self.plugInView.height);
        }];
    }else {
        filePatch =  [[JKBundleTool initBundlePathWithImage] stringByAppendingPathComponent:@"jk_morebtn"];
        [UIView performWithoutAnimation:^{
            self.tableView.frame = CGRectMake(0, self.tableView.top, self.tableView.width, self.tableView.height + 109);
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
        NSString *morePath = [[JKBundleTool initBundlePathWithImage] stringByAppendingPathComponent:@"jk_morebtn"];
        [self.moreBtn setImage:[UIImage imageWithContentsOfFile:morePath] forState:UIControlStateNormal];
        self.tableView.frame = CGRectMake(0, self.tableView.top, self.tableView.width, self.tableView.height + 109);
        self.bottomView.frame = CGRectMake(0, self.tableView.bottom, self.bottomView.width, self.bottomView.height);
        self.plugInView.frame = CGRectMake(0, self.bottomView.bottom, self.plugInView.width, self.plugInView.height);
    }
    NSString *filePatch = @"";
    if (button.selected) {
        self.faceView.hidden = NO;
        filePatch =  [[JKBundleTool initBundlePathWithImage] stringByAppendingPathComponent:@"icon_expression_hl"];
        [UIView performWithoutAnimation:^{
            self.tableView.frame = CGRectMake(0, self.tableView.top, self.tableView.width, self.tableView.height - 145);
            self.bottomView.frame = CGRectMake(0, self.tableView.bottom, self.bottomView.width, self.bottomView.height);
        }];
        
        [UIView animateWithDuration:duration animations:^{
            self.faceView.frame = CGRectMake(0, self.bottomView.bottom, self.faceView.width, self.faceView.height);
        }];
    }else {
        filePatch =  [[JKBundleTool initBundlePathWithImage] stringByAppendingPathComponent:@"icon_expression"];
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
        NSString *filePatch = [[JKBundleTool initBundlePathWithImage] stringByAppendingPathComponent:@"jk_morebtn"];
        NSString *sendImage = [[JKBundleTool initBundlePathWithImage] stringByAppendingPathComponent:@"jkmoreclick"];
        [_moreBtn setImage:[UIImage imageWithContentsOfFile:filePatch] forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage imageWithContentsOfFile:sendImage] forState:UIControlStateHighlighted];
        [_moreBtn addTarget:self action:@selector(plugInBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
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
-(void)getSimilarWithResult:(id)result {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:nil];
        if (array.count) {
            self.assoiateView.hidden = NO;
            self.assoiateView.associateArr = [[NSMutableArray alloc] initWithArray:array];
            self.assoiateView.keyWord = self.textView.text;
            CGFloat height = 33 * array.count;
            self.assoiateView.frame = CGRectMake(0, self.bottomView.top - height, self.view.width, height);
             [self.assoiateView.tableView reloadData];
        }else {
            self.assoiateView.hidden = YES;
        }
    });
}
-(void)textViewDidChange:(UITextView *)textView {
    __weak JKDialogueViewController *weakSelf = self;
    [[JKConnectCenter sharedJKConnectCenter] getSimilarQuestion:textView.text Block:^(id  _Nonnull result) {
        [weakSelf getSimilarWithResult:result];
    }];
}
- (JKMessage *)listMessage{
    if (_listMessage == nil) {
        _listMessage = [[JKMessage alloc]init];
    }
    return _listMessage;
}
-(JKAssoiateView *)assoiateView {
    if (_assoiateView == nil) {
        _assoiateView = [[JKAssoiateView alloc] init];
        _assoiateView.hidden = YES;
    }
    return _assoiateView;
}




- (JKMessageFrame *)jisuanMessageFrame:(JKMessageFrame *)message{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    // 1、计算时间的位置
    CGFloat timeY = JKChatMargin;
    message.timeF = CGRectMake(0, timeY, screenW, 17);
    CGFloat contentY = CGRectGetMaxY(message.timeF);
    CGFloat contentX = 0;
    if (message.message.whoSend !=JK_Visitor) {
        message.nameF = CGRectMake(24, CGRectGetMaxY(message.timeF) + 30, screenW - 100, 20);
        contentY = CGRectGetMaxY(message.nameF) + 4;
        contentX =  20;
    }else {
        contentY = contentY + 21;
    }
    //根据种类分
    CGSize contentSize;
    switch (message.message.messageType) {
        case JKMessageWord:
            contentSize = [self jiSuanMessageHeigthWithModel:message.message message:message.message.content font:JKChatContentFont];
            
            if ([message.message.content containsString:@"\r\n"] && message.message.whoSend != JK_Visitor) {
                contentSize.width = JKChatContentW;
            }
            
            break;
        case JKMessageImage:
            contentSize = CGSizeMake(message.message.imageWidth, message.message.imageHeight);
            break;
        case JKMessageVedio:
            contentSize = CGSizeMake(120, 20);
            break;
        default:
            break;
    }
    if (message.message.whoSend == JK_Visitor) {
        contentX = screenW -20-contentSize.width - 44;
    }
    
    if (message.message.whoSend == JK_SystemMarkShow) {
        message.contentF = CGRectMake(0, 0, contentSize.width + 44, contentSize.height);
        message.cellHeight = CGRectGetMaxY(message.contentF);
    }else{
        message.contentF = CGRectMake(contentX, contentY, contentSize.width + 44, contentSize.height);
        message.cellHeight = MAX(CGRectGetMaxY(message.contentF), CGRectGetMaxY(message.nameF))  ;
    }
    
    return message;
    
}

- (CGSize )jiSuanMessageHeigthWithModel:(JKDialogModel *)model message:(NSString *)message font:(UIFont *)font{
    if (!message.length) {
        return CGSizeZero;
    }
    
    JKRichTextStatue * richText = [[JKRichTextStatue alloc] init];
    richText.text = message;
    //再经过TextView中间过滤一次
    
    
    
    
    
    NSMutableAttributedString *attribute = [self praseHtmlStr:message];
    [attribute addAttributes:@{NSFontAttributeName: font} range:NSMakeRange(0, attribute.string.length)];
    
    CGSize size = [self getAttributedStringHeightWithText:attribute andWidth:JKChatContentW andFont:font];
    
    model.imageHeight = size.height;
    if (!model.imageWidth) {
        model.imageWidth = size.width;
    }
    return size;
}
- (NSMutableAttributedString *)praseHtmlStr:(NSString *)htmlStr {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    return attributedString;
}
/**
 *  计算富文本的高度
 */
-(CGSize)getAttributedStringHeightWithText:(NSAttributedString *)attributedString andWidth:(CGFloat)width andFont:(UIFont *)font{
    static UITextView *stringLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{//生成一个同于计算文本高度的label
        stringLabel = [[UITextView alloc] init];
        stringLabel.font = font;
    });
    
    stringLabel.attributedText = attributedString;
    CGSize size = [stringLabel sizeThatFits:CGSizeMake(width, 0)];
    CGSize ceilSize = CGSizeMake(ceil(size.width), ceil(size.height));
    return ceilSize;
}
//- (NSString *)imageBundlePath{
//    if (_imageBundlePath == nil) {
//        _imageBundlePath =  [JKBundleTool initBundlePathWithImage];
//    }
//    return _imageBundlePath;
//}
@end
