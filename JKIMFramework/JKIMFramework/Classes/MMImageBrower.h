//
//  MikaImageBrowerCollectionView.h
//  MikaImageBrower
//
//  Created by mika on 2018/4/27.
//  Copyright © 2018年 mika. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MMImageBrowerDelegate <NSObject>
@optional
- (void)mikaImageBrowerScrollToIndex:(NSInteger)index;
- (void)MikaSelectedCompleted:(NSArray *)imageAssets;
- (void)mikaImageBrowerRemoveFromSuperView:(NSArray *)imageAssets;
@end

@interface MMImageBrower : UIView

@property (nonatomic, weak) id <MMImageBrowerDelegate>        delegate;
@property (nonatomic, strong) NSArray                           *images;//url 或者 image对象
@property (nonatomic, assign) NSInteger                         currentIndex;
@property (nonatomic, strong) NSMutableArray                    *selectedArray;

- (void)show;

@end
