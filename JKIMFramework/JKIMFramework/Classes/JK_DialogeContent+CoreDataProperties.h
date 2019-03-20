//
//  JK_DialogeContent+CoreDataProperties.h
//  JKIMSDK
//
//  Created by zzx on 2019/3/19.
//  Copyright © 2019 zzx. All rights reserved.
//
//

#import "JK_DialogeContent+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface JK_DialogeContent (CoreDataProperties)

+ (NSFetchRequest<JK_DialogeContent *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *chatId;
@property (nullable, nonatomic, copy) NSString *contentUrl;
@property (nullable, nonatomic, copy) NSString *iconName;
@property (nullable, nonatomic, copy) NSString *iconUrl;
@property (nonatomic) float imageHeight;
@property (nonatomic) float imageWidth;
@property (nonatomic) BOOL isRichText;
@property (nullable, nonatomic, copy) NSString *message;
@property (nonatomic) int16_t messageType;
@property (nullable, nonatomic, copy) NSString *roomId;
@property (nullable, nonatomic, copy) NSString *time;
@property (nonatomic) int16_t whoSend;

@end

NS_ASSUME_NONNULL_END
