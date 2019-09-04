//
//  JYFaceView.h
//  JKIMSDKProject
//
//  Created by Jerry on 2019/3/19.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 点击表情传送的字符

 @param NSString 传递的字符
 */
typedef void(^ClickImageBlock)(NSString *);

@interface JYFaceView : UIView
@property (nonatomic,copy)ClickImageBlock clickBlock;

@end

NS_ASSUME_NONNULL_END
