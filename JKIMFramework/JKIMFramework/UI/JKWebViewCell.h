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

typedef void(^JKGetWebHeightBlock)(void);

@interface JKWebViewCell : UITableViewCell
@property (nonatomic, strong)JKMessageFrame *messageFrame;
@property (nonatomic,copy)JKGetWebHeightBlock webHeightBlock;
@end

NS_ASSUME_NONNULL_END
