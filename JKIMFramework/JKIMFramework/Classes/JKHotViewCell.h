//
//  JKHotViewCell.h
//  JKIMSDKProject
//
//  Created by Jerry on 2019/8/12.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKHotViewCell : UITableViewCell
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *keyWord;
@property (nonatomic,assign) BOOL isLast;
@property (nonatomic,assign) BOOL isClarify;
@end

NS_ASSUME_NONNULL_END
