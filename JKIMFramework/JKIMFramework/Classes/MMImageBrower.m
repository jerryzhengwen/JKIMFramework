
//
//  MikaImageBrowerCollectionView.m
//  MikaImageBrower
//
//  Created by mika on 2018/4/27.
//  Copyright © 2018年 mika. All rights reserved.
//

#import "MMImageBrower.h"
#import "MMImageBrowerCell.h"

#define IDENTIFIER @"MikaImageBrowerCellIdentifier"

@interface MMImageBrower ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,CellGestureDelegate>
@property (nonatomic, strong) UIWindow                      *window;
@property (nonatomic, strong) UICollectionView              *collectionView;
@property (nonatomic, strong) UIView                        *bgView;

@property (nonatomic, strong) UIPageControl                 *pageControl;
@property (nonatomic, strong) UIButton                      *backBtn;
@end

@implementation MMImageBrower {
    BOOL _popGesEnable;//记录pop手势状态
    CGFloat _oriWindowLevel;//记录pop手势状态
    CGFloat _windowLevel;//记录pop手势状态
}

static MMImageBrower *manager = nil;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.window = [UIApplication sharedApplication].delegate.window;
        self.frame = self.window.bounds;
        for (UIView *obj in self.window.subviews) {
            if ([obj isKindOfClass:[self class]]) {
                [obj removeFromSuperview];
                break;
            }
        }
        [self.window addSubview:self];
        [self initSubViews];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)show {
    _popGesEnable = [self viewController].navigationController.interactivePopGestureRecognizer.enabled;
    _oriWindowLevel = [UIApplication sharedApplication].delegate.window.windowLevel;
    self.window.windowLevel = UIWindowLevelStatusBar;
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }];
}

- (void)initSubViews {
    //初始化bgView
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.bgView.alpha                   = 1.0;
    self.bgView.backgroundColor         = [UIColor blackColor];
    [self addSubview:self.bgView];
    //初始化UICollectionViewFlowLayout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    layout.minimumInteritemSpacing      = 0;
    layout.minimumLineSpacing           = 0;
    //初始化UICollectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    [self.collectionView registerClass:[MMImageBrowerCell class] forCellWithReuseIdentifier:IDENTIFIER];
    self.collectionView.delegate        = self;
    self.collectionView.dataSource      = self;
    self.collectionView.pagingEnabled   = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.bounces         = YES;
    self.collectionView.clipsToBounds   = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
    }
    [self addSubview:self.collectionView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 50, self.frame.size.width, 50)];
    self.pageControl.hidesForSinglePage = YES;
    [self.pageControl addTarget:self action:@selector(pageControlClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.pageControl];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.backBtn.frame = CGRectMake(0, KIsiPhoneX?44:20, 50, 44);
    self.backBtn.frame = CGRectMake(0, 20, 50, 44);
    [self.backBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backBtn];
    self.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
}

- (void)backAction:(UIButton *)btn {
    [self removeSelf];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.currentIndex < 0 || self.currentIndex >= self.images.count) {
        self.currentIndex = 0;
    }
    if (self.currentIndex != 0) {
        NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    self.pageControl.numberOfPages = _images.count;
    self.pageControl.currentPage = _currentIndex;
}

- (void)setImages:(NSArray *)images {
    _images = images;
    self.pageControl.numberOfPages = _images.count;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    self.pageControl.currentPage = _currentIndex;
}
#pragma mark - collectionView - 代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MMImageBrowerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER forIndexPath:indexPath];
    cell.collectionV = collectionView;
    cell.delegate = self;
    cell.imageSource = self.images[indexPath.row];
    cell.canShowToast = YES;
    for (UIGestureRecognizer *ges in cell.subImageView.gestureRecognizers) {
        if ([ges isKindOfClass:[UITapGestureRecognizer class]]) {
            [ges requireGestureRecognizerToFail:self.collectionView.panGestureRecognizer];
        }
    }
    
    return cell;
}

#pragma mark - 移除图片浏览器
- (void)removeSelf {
    self.bgView.alpha = 0.80;
    MMImageBrowerCell *cell = [self.collectionView visibleCells].firstObject;
    [self gestureEnd:NO cell:cell];
}

#pragma mark - UIScrollView-代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/self.collectionView.frame.size.width;
    self.currentIndex = index;
//    NSLog(@"显示的是第%ld个",index);
}

#pragma mark - cell-手势-代理
//手势开始
- (void)gestureBegan:(CGPoint)imgCenter {
    
}
//手势改变
- (void)gestureChange:(CGFloat)alpha cell:(MMImageBrowerCell *)cell point:(CGPoint)point {
    NSArray *cells = [self.collectionView visibleCells];
    if (cells.count==1) {
        if (self.bgView.alpha > 0.99) {
            self.collectionView.scrollEnabled = YES;
        }else{
            self.collectionView.scrollEnabled = NO;
        }
        self.bgView.alpha = alpha;
        cell.scroll.frame = CGRectMake(0, point.y, cell.frame.size.width, cell.frame.size.height);
    }else{
        self.collectionView.scrollEnabled = YES;
    }
}
//手势结束
- (void)gestureEnd:(BOOL)isUP cell:(MMImageBrowerCell *)cell{
    self.collectionView.scrollEnabled = YES;
    if (self.bgView.alpha > 0.85) {
        [UIView animateWithDuration:0.25 animations:^{
            self.bgView.alpha = 1.0;
            cell.scroll.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
        }];
    }else{
        if (isUP) {
            [UIView animateWithDuration:0.25 animations:^{
                self.bgView.alpha = 0.0;
                cell.scroll.frame = CGRectMake(0, -cell.frame.size.height, cell.frame.size.width, cell.frame.size.height);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }else{
            [UIView animateWithDuration:0.25 animations:^{
                self.bgView.alpha = 0.0;
                cell.scroll.frame = CGRectMake(0, cell.frame.size.height, cell.frame.size.width, cell.frame.size.height);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
        [self viewController].navigationController.interactivePopGestureRecognizer.enabled = _popGesEnable;
        self.window.windowLevel = _oriWindowLevel;
        if ([self.delegate respondsToSelector:@selector(mikaImageBrowerRemoveFromSuperView:)]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.delegate mikaImageBrowerRemoveFromSuperView:self.selectedArray];
            });
        }
    }
}

- (void)gestureTap {
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 0);
        self.bgView.alpha = 0.0;
    }completion:^(BOOL finished) {
        [self viewController].navigationController.interactivePopGestureRecognizer.enabled = self->_popGesEnable;
        self.window.windowLevel = _oriWindowLevel;
        if ([self.delegate respondsToSelector:@selector(mikaImageBrowerRemoveFromSuperView:)]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.delegate mikaImageBrowerRemoveFromSuperView:self.selectedArray];
            });
        }
    }];
}

- (void)pageControlClick:(UIPageControl *)pageControl {
//    NSLog(@"%ld",pageControl.currentPage);
    self.currentIndex = pageControl.currentPage;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:pageControl.currentPage inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)showAlertWithTitle:(NSString *)title{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [[self viewController] presentViewController:alert animated:YES completion:nil];
}
@end
