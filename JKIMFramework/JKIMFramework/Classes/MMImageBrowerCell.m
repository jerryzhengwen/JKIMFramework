//
//  MikaImageBrowerCell.m
//  MikaImageBrower
//
//  Created by mika on 2018/4/27.
//  Copyright © 2018年 mika. All rights reserved.
//

#import "MMImageBrowerCell.h"
#define minScale  1
#define maxScale  3
@interface MMImageBrowerCell ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@end


@implementation MMImageBrowerCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self.contentView addSubview:self.scroll];
    [self.scroll addSubview:self.subImageView];
    [self.contentView addSubview:self.indicatorView];
    [self.contentView addSubview:self.toastBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scroll.frame = self.bounds;
    self.scroll.zoomScale = 1.0;
    self.scroll.alwaysBounceHorizontal = YES;
    self.scroll.alwaysBounceVertical = YES;
    self.scroll.delegate = self;
    self.indicatorView.frame = CGRectMake((CGRectGetWidth(self.contentView.frame) - 100)/2.0, (CGRectGetHeight(self.contentView.frame) - 100)/2.0, 100, 100);
    self.toastBtn.frame = CGRectMake((CGRectGetWidth(self.contentView.frame) - 120)/2.0, (CGRectGetHeight(self.contentView.frame) - 30)/2.0, 120, 30);
    
    [self fixImageViewFrame];
}

- (void)setImageSource:(id)imageSource {
    _imageSource = imageSource;
    if ([_imageSource isKindOfClass:[UIImage class]]) {
        self.image = _imageSource;
    }else {
        self.indicatorView.hidden = NO;
        [self.indicatorView startAnimating];
        //1.获取一个全局串行队列
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //2.把任务添加到队列中执行
        dispatch_async(queue, ^{
            NSURL *url = [NSURL URLWithString:self->_imageSource];
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            UIImage * bgImage = [UIImage imageWithData:imageData];
            //3.回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = bgImage;
                if (self.image == nil) {
//                    self.image = [UIImage imageNamed:@"MM_imageLoadFail_placholder"];
                }
                self.indicatorView.hidden = YES;
                [self.indicatorView stopAnimating];
            });
        });
    }
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.subImageView.image = _image;
    [self layoutSubviews];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.subImageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    [scrollView setZoomScale:scale];
    if (self.canShowToast) {
        if (scrollView.zoomScale >= 2.0) {
            [self showToast];
        }
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    NSLog(@"%lf",scrollView.zoomScale);
    if (scrollView.zoomScale == 1.0) {
        self.pan.enabled = YES;
    }else {
        self.pan.enabled = NO;
    }
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = self.subImageView.frame;
    CGSize contentSize = scrollView.contentSize;
    CGPoint centerPoint = CGPointMake(contentSize.width / 2, contentSize.height / 2);
    if (imgFrame.size.width <= boundsSize.width)
    {
        centerPoint.x = boundsSize.width / 2;
    }
    if (imgFrame.size.height <= boundsSize.height)
    {
        centerPoint.y = boundsSize.height / 2;
    }
    self.subImageView.center = centerPoint;
}

- (void)fixImageViewFrame {
    CGFloat imgW = ceil(_image.size.width);
    CGFloat imgH = ceil(_image.size.height);
    CGFloat scale = 0.0;
    CGFloat W = 0.0;
    CGFloat H = 0.0;
    if (imgW == imgH) {
        scale = 1.0;
        W = self.scroll.frame.size.width;
        H = imgH * scale;
    }else {
        if (imgW > imgH || (imgH/imgW <= self.frame.size.height/self.frame.size.width)) {//宽撑满
            CGFloat min = MIN(imgW, self.scroll.frame.size.width);
            CGFloat max = MAX(imgW, self.scroll.frame.size.width);
            scale = min/max;
            W = self.scroll.frame.size.width;
            H = imgH * scale;
            H = (imgH *W)/imgW;
        }else {
            CGFloat min = MIN(imgH, self.scroll.frame.size.height);
            CGFloat max = MAX(imgH, self.scroll.frame.size.height);
            scale = min/max;
            H = self.scroll.frame.size.height;
            W = imgW * scale;
            W = (imgW * H)/imgH;
            
        }
    }
    self.subImageView.frame = CGRectMake((self.scroll.frame.size.width - W)/2.0, (self.scroll.frame.size.height - H)/2.0, W, H);
}

#pragma mark - 手势代理方法 多手势 互斥
-(BOOL)gestureRecognizer:(UIGestureRecognizer*) gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer
{
    if ([gestureRecognizer.view isKindOfClass:[UICollectionView class]]) {
        return NO;
    }else{
        return YES;
    }
}


#pragma mark - 手势执行操作
- (void)pan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:pan.view];
    CGFloat alpha = (self.frame.size.height-fabs(point.y))/self.frame.size.height;
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            if ([self.delegate respondsToSelector:@selector(gestureBegan:)]) {
                [self.delegate gestureBegan:pan.view.center];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if ([self.delegate respondsToSelector:@selector(gestureChange:cell:point:)]) {
                [self.delegate gestureChange:alpha cell:self point:point];
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            BOOL UP = NO;
            if (point.y < 0) {
                UP = YES;
            }
            if ([self.delegate respondsToSelector:@selector(gestureEnd:cell:)]) {
                [self.delegate gestureEnd:UP cell:self];
            }
            break;
        }
            
        case UIGestureRecognizerStateCancelled: {
            if ([self.delegate respondsToSelector:@selector(gestureCancle:cell:)]) {
                [self.delegate gestureCancle:alpha cell:self];
            }
            break;
        }
        case UIGestureRecognizerStateFailed: {
            if ([self.delegate respondsToSelector:@selector(gestureFailed:cell:)]) {
                [self.delegate gestureFailed:alpha cell:self];
            }
            break;
        }
        default:
            break;
    }
}

- (void)tap:(UIGestureRecognizer *)ges {
    if ([self.delegate respondsToSelector:@selector(gestureTap)]) {
        [self.delegate gestureTap];
    }
}


- (void)doubleTap:(UIGestureRecognizer *)ges {
    if (self.scroll.zoomScale > 1.0) {
        [self.scroll setZoomScale:1.0 animated:YES];
    }else {
        [self.scroll setZoomScale:2.0 animated:YES];
    }
}

- (void)showToast {
    self.canShowToast = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.toastBtn.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hiddenToast) withObject:nil afterDelay:0.25];
    }];
}

- (void)hiddenToast {
    [UIView animateWithDuration:0.25 animations:^{
        self.toastBtn.alpha = 0.0;
    }];
}

#pragma mark - 懒加载
- (UIScrollView *)scroll {
    if (!_scroll) {
        _scroll = [[UIScrollView alloc] init];
        _scroll.delegate = self;
        _scroll.minimumZoomScale = minScale;
        _scroll.maximumZoomScale = maxScale;
        [_scroll setZoomScale:minScale animated:YES];
        if (@available(iOS 11.0, *)) {
            _scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tap.delegate = self;
        [_scroll addGestureRecognizer:tap];
    }
    return _scroll;
}

- (UIImageView *)subImageView {
    if (!_subImageView) {
        _subImageView = [[UIImageView alloc] init];
        _subImageView.contentMode = UIViewContentModeScaleAspectFit;
        _subImageView.clipsToBounds = YES;
        _subImageView.userInteractionEnabled = YES;
        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        self.pan.delegate = self;
        [_subImageView addGestureRecognizer:self.pan];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tap.delegate = self;
        tap.numberOfTapsRequired = 2;
        [_subImageView addGestureRecognizer:tap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.delegate = self;
        doubleTap.numberOfTapsRequired = 2;
        [_subImageView addGestureRecognizer:doubleTap];
        
        [tap requireGestureRecognizerToFail:doubleTap];
    }
    return _subImageView;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] init];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _indicatorView.backgroundColor = [UIColor grayColor];
        _indicatorView.layer.cornerRadius = 10.0;
        _indicatorView.layer.masksToBounds = YES;
        _indicatorView.alpha = 0.4;
    }
    return _indicatorView;
}

- (UIButton *)toastBtn {
    if (!_toastBtn) {
        _toastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_toastBtn setTitle:@"进入放大模式" forState:UIControlStateNormal];
        _toastBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_toastBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _toastBtn.userInteractionEnabled = NO;
        _toastBtn.alpha = 0.0;
        _toastBtn.layer.cornerRadius = 5.0;
        _toastBtn.layer.masksToBounds = YES;
        _toastBtn.backgroundColor = [UIColor colorWithRed:100/255 green:100/255 blue:100/255 alpha:1.0];
    }
    return _toastBtn;
}

@end
