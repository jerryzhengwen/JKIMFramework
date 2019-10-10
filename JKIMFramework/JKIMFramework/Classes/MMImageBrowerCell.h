//
//  MikaImageBrowerCell.h
//  MikaImageBrower
//
//  Created by mika on 2018/4/27.
//  Copyright © 2018年 mika. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MMImageBrowerCell;
@protocol CellGestureDelegate <NSObject>
@optional
- (void)gestureBegan:(CGPoint)imgCenter;
- (void)gestureChange:(CGFloat)alpha cell:(MMImageBrowerCell *)cell point:(CGPoint)point;
- (void)gestureEnd:(BOOL)isUP cell:(MMImageBrowerCell *)cell;
- (void)gestureFailed:(CGFloat)alpha cell:(MMImageBrowerCell *)cell;
- (void)gestureCancle:(CGFloat)alpha cell:(MMImageBrowerCell *)cell;
- (void)gestureTap;
@end


@interface MMImageBrowerCell : UICollectionViewCell
@property (nonatomic, weak) id<CellGestureDelegate>     delegate;
@property (nonatomic, weak) UICollectionView            *collectionV;

@property (nonatomic, strong) UIScrollView              *scroll;
@property (nonatomic, strong) UIImageView               *subImageView;
@property (nonatomic, strong) UIActivityIndicatorView   *indicatorView;//指示框
@property (nonatomic, strong) UIButton                  *toastBtn;//用于显示是否进入了放大模式
@property (nonatomic, assign) BOOL                      canShowToast;
@property (nonatomic, strong) id                        imageSource;
@property (nonatomic, strong) UIImage                   *image;
@property (nonatomic, strong) UIPanGestureRecognizer    *pan;


@end
