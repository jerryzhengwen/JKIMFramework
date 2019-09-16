//
//  JKWebViewCell.h
//  JKIMSDKProject
//
//  Created by Jerry on 2019/8/24.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKMessageFrame.h"
NS_ASSUME_NONNULL_BEGIN

//@class JKMessageFrame;

typedef void(^JKGetWebHeightBlock)(int row,BOOL moveToLast);
typedef void(^JKShowBigImageBlock)(UIImageView *);


@interface JKWebViewCell : UITableViewCell
@property (nonatomic, strong)JKMessageFrame *messageFrame;
@property (nonatomic,assign) int reloadRow;
@property (nonatomic,copy)JKGetWebHeightBlock webHeightBlock;
@property (nonatomic,copy)JKShowBigImageBlock showImgBlock;

@end

NS_ASSUME_NONNULL_END
