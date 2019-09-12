//
//  UUAVAudioPlayer.m
//  BloodSugarForDoc
//
//  Created by zzx on 2019/3/12.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKImageAvatarBrowser.h"

static UIImageView *orginImageView;
static UIScrollView *scrollView;
@interface JKImageAvatarBrowser()<UIScrollViewDelegate>

@end

@implementation JKImageAvatarBrowser

+(void)showImage:(UIImageView *)avatarImageView{
    UIImage *image=avatarImageView.image;
    orginImageView = avatarImageView;
    orginImageView.alpha = 0;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    CGRect oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    scrollView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:1];
    scrollView.alpha=1;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [scrollView addSubview:imageView];
    [window addSubview:scrollView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [scrollView addGestureRecognizer: tap];
    
    [scrollView setMinimumZoomScale:0.5f];
    [scrollView setMaximumZoomScale:1.8f];
    scrollView.userInteractionEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.delegate = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        scrollView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

+(void)hideImage:(UITapGestureRecognizer*)tap{
    
    if (tap.numberOfTouches == 2) {
        float newScale = scrollView.zoomScale * 1.5;//zoomScale这个值决定了contents当前扩展的比例
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[tap locationInView:tap.view]];
        [scrollView zoomToRect:zoomRect animated:YES];
        return;
    }
    
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=[orginImageView convertRect:orginImageView.bounds toView:[UIApplication sharedApplication].keyWindow];
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        orginImageView.alpha = 1;
        backgroundView.alpha=0;
    }];
}

+ (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = scrollView.frame.size.height / scale;
    NSLog(@"zoomRect.size.height is %f",zoomRect.size.height);
    NSLog(@"self.frame.size.height is %f",scrollView.frame.size.height);
    zoomRect.size.width  = scrollView.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

@end
