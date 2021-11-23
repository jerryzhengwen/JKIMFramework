//
//  JKMsgSendStatusView.h
//  JKIMSDKProject
//
//  Created by 陈天栋 on 2021/10/12.
//  Copyright © 2021 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKENUMObject.h"
#import "JKBundleTool.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^reSendMessageBlock)(void);

@interface JKMsgSendStatusView : UIView

@property (nonatomic,assign)JKMsgSendStatus msgSendStatus;

@property (nonatomic,copy)reSendMessageBlock reSendMsgBlock;
@end

NS_ASSUME_NONNULL_END
