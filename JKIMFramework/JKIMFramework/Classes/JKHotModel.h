//
//  JKHotModel.h
//  JKIMSDKProject
//
//  Created by Jerry on 2019/8/5.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKHotModel : NSObject
@property (nonatomic,copy) NSString * hotId;
@property (nonatomic,copy) NSString *standard_question_id;
@property (nonatomic,copy) NSString *question;
@property (nonatomic,assign) int sort;
@property (nonatomic,assign) int source;

@end

NS_ASSUME_NONNULL_END
