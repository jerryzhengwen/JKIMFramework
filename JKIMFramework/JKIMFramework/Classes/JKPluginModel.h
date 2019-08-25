//
//  JKPluginModel.h
//  JKIMSDKProject
//
//  Created by Jerry on 2019/4/2.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKPluginModel : NSObject

///标题
@property(nonatomic,copy) NSString *title;
///图片url
@property(nonatomic,copy) NSString *iconUrl;

@end

NS_ASSUME_NONNULL_END
