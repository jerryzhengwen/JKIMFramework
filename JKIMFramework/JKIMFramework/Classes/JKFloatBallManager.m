//
//  JKFloatBallManager.m
//  JKIMSDKProject
//
//  Created by zzx on 2019/3/8.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKFloatBallManager.h"
#import "JKFloatBallDefine.h"
#import "NSObject+JKCurrentVC.h"
#import "UIView+JKFloatFrame.h"
#import "JKDialogueViewController.h"
#import "JKBundleTool.h"
#import <objc/runtime.h>
#import "JKConnectCenter.h"

/** 悬浮球显示状态 */
typedef NS_ENUM(NSInteger, FloatShowStyle) {
    FloatShowStyleNormal,     //悬浮球隐藏，正常状态
    FloatShowStyleShow,       //悬浮球显示，有缩小的控制器
    FloatShowStyleShowContent //正在显示悬浮球里的内容，悬浮球alpha变成0
};

@interface JKFloatBallManager()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>{
    
}

/** 需要监控的类名 */
@property (nonatomic, strong) NSMutableArray<NSString *> *monitorVCClasses;
/** 悬浮球显示模式 */
@property (nonatomic, assign) FloatShowStyle showStyle;
/** 手势是否在右下角圆内 */
@property (nonatomic, assign) BOOL touchInRound;
/** 栈顶即将要pop的控制器 */
@property (nonatomic, strong) UIViewController *lastPopViewController;
/** 悬浮球加载的控制器 */
@property (nonatomic, strong) UIViewController *floatViewController;
/** 悬浮球 */
@property (nonatomic, strong) UIImageView *floatView;
/** 跳转的第二个控制器*/
@property(nonatomic, strong)JKDialogueViewController *secondVC;

/** 启动定时循环*/
@property(nonatomic, strong)dispatch_source_t timer;
/** 是否启动定时循环播放图片 */
@property (nonatomic, assign,getter=isPlayTimer) BOOL playTimer;


@end

NSString *const kPopInteractiveKey = @"kPopInteractiveKey";
NSString *const kAnimatorKey = @"kAnimatorKey";
//是否为右滑手势引起的pop操作
NSString *const kPopWithPanGes = @"kPopWithPanGes";

@implementation JKFloatBallManager


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    dispatch_source_cancel(self.timer);
    self.timer = nil;
}

+ (instancetype)shared {
    static JKFloatBallManager *floatManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        floatManager = [[super allocWithZone:nil] init];
        floatManager.monitorVCClasses = [NSMutableArray array];
        [NSObject currentNavigationController].interactivePopGestureRecognizer.delegate = floatManager;
        [NSObject currentNavigationController].delegate = floatManager;
        [[NSNotificationCenter defaultCenter] addObserver:floatManager selector:@selector(p_animationWillBegin) name:AnimationWillBeginKey object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:floatManager selector:@selector(p_animationWillEnd) name:AnimationWillEndKey object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:floatManager selector:@selector(p_animationDidEnd:) name:AnimationDidEndKey object:nil];
        
        
    });
    return floatManager;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [JKFloatBallManager shared];
}

- (id)copyWithZone:(NSZone *)zone {
    return [JKFloatBallManager shared];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [JKFloatBallManager shared];
}

#pragma mark - Public
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    ///未读数
    NSInteger unreadCount = [change[@"new"] integerValue];
    
    if (unreadCount > 0) {
        
        __weak typeof(self) weakSelf = self;
        dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(self.timer, ^{
            [weakSelf changeImage];
        });
        
        if (self.isPlayTimer == NO) {
            self.playTimer = YES;
            dispatch_resume(self.timer);
        }
        
        
    }else{
        
        self.floatView.highlighted = NO;
        if (self.isPlayTimer == YES) {
            self.playTimer = NO;
            dispatch_suspend(self.timer);
        }
        
    }
    
    NSLog(@"%ld",unreadCount);
    
}

- (void)changeImage{
    self.floatView.highlighted = !self.floatView.highlighted;
}

- (void)didShowViewController:(UIViewController *)viewController navigationController:(UINavigationController *)navigationController
{
    if ([self.monitorVCClasses containsObject:NSStringFromClass([viewController class])]) {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
        // 边缘手势
        UIScreenEdgePanGestureRecognizer *gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleNavigationTransition:)];
        gesture.edges = UIRectEdgeLeft;
        gesture.delegate = self;
        [viewController.view addGestureRecognizer:gesture];
    }
    else {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark - 手势
#pragma mark 自身添加的右滑返回手势
- (void)handleNavigationTransition:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:[UIApplication sharedApplication].keyWindow];
    //转场交互
    UIPercentDrivenInteractiveTransition *interactive = objc_getAssociatedObject(self.lastPopViewController, &kPopInteractiveKey);
    //转场动画
//    JKFloatTransitionAnimator *animator = objc_getAssociatedObject(self.lastPopViewController, &kAnimatorKey);
    
    //未显示悬浮球内容
    BOOL notShowFloatContent = (self.showStyle == FloatShowStyleNormal || self.showStyle == FloatShowStyleShow);
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (notShowFloatContent && self.showStyle == FloatShowStyleShow && self.floatViewController != self.lastPopViewController) {
            //            [self.cancelFloatView setCancelFloatViewShowing:NO];
        }
        objc_setAssociatedObject([NSObject currentNavigationController], &kPopWithPanGes, [NSNumber numberWithBool:YES], OBJC_ASSOCIATION_ASSIGN);
        [[NSObject currentNavigationController] popViewControllerAnimated:YES];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat progress = point.x / FloatScreenWidth;
        //未显示悬浮球内容时，显示1/4圆
        if (notShowFloatContent) {
            // 屏幕滑动到1/6的时候右下角视图开始出现，滑动到一半，完全出现
            //            if (point.x >= FloatScreenWidth / 6.0 && point.x <= FloatScreenWidth / 2.0) {
            //                CGFloat progress = (point.x - FloatScreenWidth / 6.0) / (FloatScreenWidth / 2.0 - FloatScreenWidth / 6.0);
            //                [self.cancelFloatView showCancelFloatViewWithProress:progress completion:nil];
            //            }
            [self p_floatMoveWithPoint:point];
        }
        else { //显示悬浮球内容时，改变悬浮球透明度
            self.floatView.alpha = progress;
        }
        //更新转场动画进度
//        [animator updateInteractiveTransition:progress];
        [interactive updateInteractiveTransition:progress];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||
             gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        objc_setAssociatedObject([NSObject currentNavigationController], &kPopWithPanGes, [NSNumber numberWithBool:NO], OBJC_ASSOCIATION_ASSIGN);
        if (notShowFloatContent) {
            //            [self.cancelFloatView showCancelFloatViewWithProress:0 completion:nil];
        }
        //快速滑动时，通过手势加速度算出动画执行时间可移动距离，模拟系统快速拖动时可pop操作
        CGPoint velocityPoint = [gestureRecognizer velocityInView:[UIApplication sharedApplication].keyWindow];
        CGFloat velocityX = velocityPoint.x * AnimationDuration;
        //滑动超过屏幕一半，完成转场
        if (fmax(velocityX, point.x) > FloatScreenWidth / 2.0) {
            if (notShowFloatContent) {
                //右滑手势，滑动至右下角1/4圆内则显示悬浮球
                //                if ([self p_checkTouchPointInRound:point]) {
                [self p_animationWillEnd];
                self.floatViewController = self.lastPopViewController;
                //更新转场动画，从当前触摸点开始缩小到悬浮点位置
//                [animator replaceAnimation];
                //                }
                //                else {
                //                    [animator continueAnimationWithFastSliding:velocityX > FloatScreenWidth / 2.0];
                //                }
            }
            else { //正在显示悬浮球内容
                //右滑手势拖动超过一半，手指离开屏幕，也会从当前触摸位置缩小到悬浮球
//                [animator replaceAnimation];
                [self p_animationWillEnd];
            }
            [interactive finishInteractiveTransition];
        }
        else {  //未触发pop，取消转场操作，动画回归
//            [animator cancelInteractiveTransition];
            if (!notShowFloatContent) {
                self.floatView.alpha = 0;
            }
            [interactive cancelInteractiveTransition];
        }
        self.lastPopViewController = nil;
    }
}



#pragma mark 点击悬浮球，push到缩小的控制器
- (void)tapFloatView:(UITapGestureRecognizer *)ges
{
    if ([[[NSObject currentNavigationController].childViewControllers lastObject] isEqual:self.floatView]) {
        return;
    }
    //    [self.cancelFloatView setCancelFloatViewShowing:YES];
    
    if (self.secondVC == nil) {
        self.secondVC = [[JKDialogueViewController alloc]init];
        self.floatViewController = self.secondVC;
        self.lastPopViewController = self.secondVC;
    }
    
    [self.secondVC setHidesBottomBarWhenPushed:YES];
    
    if ([[NSObject currentNavigationController].topViewController isKindOfClass:[self.floatViewController class]]) {
        return;
    }
    
    [[NSObject currentNavigationController] pushViewController:self.floatViewController animated:YES];
}

- (void)dragFloatView:(UIPanGestureRecognizer *)ges
{
    CGPoint inSuperViewPoint = [ges locationInView:ges.view.superview];
    if (ges.state == UIGestureRecognizerStateBegan) {
        
        //        [self.cancelFloatView setCancelFloatViewShowing:YES];
        //        [self.cancelFloatView showCancelFloatViewWithProress:1 completion:nil];
    }
    else if (ges.state == UIGestureRecognizerStateChanged) {
        //translationInView 以在ges.view上拖动点为坐标原点的相对位移
        CGPoint transitionP = [ges translationInView:ges.view];
        CGFloat transitionX = MAX(FloatWidth / 2.0, MIN(self.floatView.center.x + transitionP.x, FloatScreenWidth - FloatWidth / 2.0));
        CGFloat transitionY = MAX(FloatWidth / 2.0, MIN(self.floatView.center.y + transitionP.y, FloatScreenHeight - FloatWidth / 2.0));
        self.floatView.center = CGPointMake(transitionX, transitionY);
        [ges setTranslation:CGPointZero inView:ges.view];
        //移动过程中监控坐标位置是否进入右下角圆内
        [self p_floatMoveWithPoint:inSuperViewPoint];
    }
    else if (ges.state == UIGestureRecognizerStateEnded || ges.state ==  UIGestureRecognizerStateCancelled) {
        //        FloatWeakSelf
        //手势结束，处理右下角1/4圆
        //        [self.cancelFloatView showCancelFloatViewWithProress:0 completion:^{
        //圆消失后再将状态重置，防止在执行消失过程中让用户看见
        //            FloatStrongSelf
        //            if ([self p_checkTouchPointInRound:inSuperViewPoint]) {
        //                [self.cancelFloatView setCancelFloatViewShowing:NO];
        //            }
        //        }];
        
        //手势结束，处理悬浮球
        //        if ([self p_checkTouchPointInRound:inSuperViewPoint]) {
        //            // 手势在右下角1/4圆内停留，则隐藏悬浮窗口并且将缓存的控制器释放
        //            [self p_clearControllerAnimatorAndInteractive:self.lastPopViewController];
        //            self.floatViewController = nil;
        //            self.lastPopViewController = nil;
        //            //悬浮球跟圆同时往右下移出屏幕
        //            [UIView animateWithDuration:FloatTranslationOutDuration animations:^{
        //                self.floatView.origin = CGPointMake(FloatScreenWidth, FloatScreenHeight);
        //            } completion:^(BOOL finished) {
        //                self.showStyle = FloatShowStyleNormal;
        //            }];
        //        }
        //        else {
        //手势结束，悬浮球不在圆内，让悬浮球靠边
        [UIView animateWithDuration:FloatTranslationOutDuration animations:^{
            CGFloat minX = FloatMargin;
            CGFloat maxX = FloatScreenWidth - self.floatView.width - FloatMargin;
            CGFloat minY = FloatMargin;
            CGFloat maxY = FloatScreenHeight - self.floatView.height - FloatMargin;
            CGPoint point = CGPointZero;
            if (self.floatView.centerX < FloatScreenWidth / 2.0) {
                point.x = minX;
                point.y = MIN(MAX(minY, self.floatView.y), maxY);
            }
            else {
                point.x = maxX;
                point.y = MIN(MAX(minY, self.floatView.y), maxY);
            }
            self.floatView.origin = point;
        }];
        //        }
    }
}

#pragma mark - NSNotificationCenter

- (void)p_animationWillBegin
{
    self.showStyle = FloatShowStyleShowContent;
}

- (void)p_animationWillEnd
{
    self.showStyle = FloatShowStyleShow;
}

- (void)p_animationDidEnd:(NSNotification *)notification
{
    UIViewController *fromVC = notification.object;
    [self p_clearControllerAnimatorAndInteractive:fromVC];
}

#pragma mark - Private
#pragma mark 悬浮球移动到右下角1/4圆内则隐藏悬浮球
- (void)p_floatMoveWithPoint:(CGPoint)point
{
    BOOL inRound = [self p_checkTouchPointInRound:point];
    if (_touchInRound != inRound) {
        _touchInRound = inRound;
        if (inRound) {
            //进入圆内，改变状态并震动手动
            //            [self.cancelFloatView moveWithTouchInRound:YES];
            [self p_shockPhone];
        }
        else {
            //            [self.cancelFloatView moveWithTouchInRound:NO];
        }
    }
}

//判断手势触摸点是否在圆内
- (BOOL)p_checkTouchPointInRound:(CGPoint)point
{
    CGPoint center = CGPointMake(FloatScreenWidth, FloatScreenHeight);
    double dx = fabs(point.x - center.x);
    double dy = fabs(point.y - center.y);
    double distance = hypot(dx, dy);
    //触摸点到圆心的距离小于半径，则代表触摸点在圆内
    return distance < RoundViewRadius;
}

#pragma mark 手势清除controller绑定的转场动画与转场交互
- (void)p_clearControllerAnimatorAndInteractive:(UIViewController *)vc
{
    objc_setAssociatedObject(vc, &kPopInteractiveKey, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(vc, &kAnimatorKey, nil, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - 手机震动
- (void)p_shockPhone
{
    static BOOL canShock = YES;
    if (@available(iOS 10.0, *)) {
        if (!canShock) {
            return;
        }
        canShock = NO;
        UIImpactFeedbackGenerator *impactFeedBack = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [impactFeedBack prepare];
        [impactFeedBack impactOccurred];
        //防止同时触发几个震动
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            canShock = YES;
        });
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([NSObject currentNavigationController].viewControllers.count > 1) {
        if ([self.monitorVCClasses containsObject:NSStringFromClass([JKDialogueViewController class])]) {
            [[UIApplication sharedApplication].keyWindow addSubview:self.floatView];
            self.lastPopViewController = self.secondVC;
        }
        else {
            self.lastPopViewController = nil;
        }
        return YES;
    }
    return NO;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[JKFloatBallManager shared] didShowViewController:viewController navigationController:navigationController];
}

#pragma mark - setter

- (void)setShowStyle:(FloatShowStyle)showStyle
{
    _showStyle = showStyle;
    switch (showStyle) {
        case FloatShowStyleNormal:
            self.floatView.hidden = YES;
            //回到普通状态，重置悬浮球位置
            self.floatView.origin = CGPointMake(FloatScreenWidth - FloatWidth - FloatMargin, FloatScreenHeight - RoundViewRadius - FloatWidth);
            break;
        case FloatShowStyleShow:
            self.floatView.alpha = 1;
            self.floatView.hidden = NO;
            break;
        case FloatShowStyleShowContent:
            self.floatView.alpha = 0;
            self.floatView.hidden = NO;
            break;
    }
}

#pragma mark - getter

- (UIImageView *)floatView
{
    if (!_floatView) {
        
        
        _floatView = [[UIImageView alloc] init];
        NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
        NSString *filePatch = [bundlePatch stringByAppendingPathComponent:@"contact_icon"];
        _floatView.image = [UIImage imageWithContentsOfFile:filePatch];
        NSString *highlightedfilePatch = [bundlePatch stringByAppendingPathComponent:@"receiveMessage_icon"];
        _floatView.highlightedImage = [UIImage imageWithContentsOfFile:highlightedfilePatch];
        
        //        _floatView.layer.cornerRadius = 30;
        //        _floatView.layer.masksToBounds = YES;
        _floatView.backgroundColor = [UIColor clearColor];
        _floatView.userInteractionEnabled = YES;
        //        _floatView.contentMode = UIViewContentModeCenter;
        _floatView.frame = CGRectMake(FloatScreenWidth - FloatWidth - FloatMargin, FloatScreenHeight - RoundViewRadius - FloatWidth, FloatWidth, FloatWidth);
        _floatView.hidden = YES;
        //添加拖动手势
        [_floatView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragFloatView:)]];
        //添加点击手势
        [_floatView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFloatView:)]];
    }
    return _floatView;
}

- (dispatch_source_t)timer{
    if (_timer == nil) {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    }
    return _timer;
}

- (void)hiddenFloatBall{
    self.showStyle = FloatShowStyleShowContent;
}


/**
 删除聊天界面
 */
- (void)removeDialogueVC{
    [self.secondVC removeFromParentViewController];
    self.showStyle = FloatShowStyleShowContent;
    self.lastPopViewController = nil;
    self.floatViewController = nil;
    self.showStyle = FloatShowStyleShow;
    self.secondVC = nil;
}

/**
 显示
 */
- (void)showFloatBall{
    if (self.showStyle == FloatShowStyleNormal) {
        self.showStyle = FloatShowStyleShow;
        [[UIApplication sharedApplication].keyWindow addSubview:self.floatView];
        
        //注册一个监听器用于监听指定的key路径
        [[JKConnectCenter sharedJKConnectCenter] addObserver:[JKFloatBallManager shared] forKeyPath:@"unreadCount" options:NSKeyValueObservingOptionNew context:nil];
    }else{
        self.showStyle = FloatShowStyleShow;
    }
    
    self.lastPopViewController = nil;
}

@end
