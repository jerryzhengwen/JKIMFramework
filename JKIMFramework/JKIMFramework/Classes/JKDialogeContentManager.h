//
//  JKDialogeContentManager.h
//  JKIMSDK
//
//  Created by Jerry on 2019/3/18.
//  Copyright © 2019 zzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
NS_ASSUME_NONNULL_BEGIN

@interface JKDialogeContentManager : NSObject
/**
 上下文 容器
 存放的是  所有从数据库中取出的转换成OC对象
 */
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;

/**
 读取解析 .momd文件的内容
 */
@property (nonatomic,strong) NSManagedObjectModel * managedObjectModel;

/**
 连接的类，处理数据库数据和OC数据底层的相互转换
 */
@property (nonatomic,strong) NSPersistentStoreCoordinator * persistentStoreCoordinator;

/**
 单例
 
 @return 返回对象本身
 */
+(instancetype)sharedInstance;
/** 插入数据
 @param dict 字典中的键值对必须要与实体中的每个名字一一对应
 @param success 成功回调
 @param fail 失败回调
 */
- (void)insertNewEntity:(NSDictionary *)dict success:(void(^)(void))success fail:(void(^)(NSError *error))fail;
/**
 查询数据
 
 @param selectKays selectKays 数组高级排序（数组里存放实体中的key，顺序按自己需要的先后存放即可），实体key来排序
 @param isAscending 升序降序
 @param filterString 查询条件
 @param success 成功回调
 @param fail 失败回调
 */
- (void)selectEntity:(NSArray *)selectKays ascending:(BOOL)isAscending filterString:(NSString *)filterString success:(void(^)(NSArray *results))success fail:(void(^)(NSError *error))fail;
/**
 删除数据
 @param model NSManagedObject
 @param success 成功回调
 @param fail 失败回调
 */
- (void)deleteEntity:(NSManagedObject *)model success:(void(^)(void))success fail:(void(^)(NSError *error))fail;
/**
 更新数据
 @param success 成功回调
 @param fail 失败回调
 */
- (void)updateEntity:(void(^)(void))success fail:(void(^)(NSError *error))fail;

-(NSMutableArray *)quaryWithConditionArray:(NSArray *)conditionArray;
@end

NS_ASSUME_NONNULL_END
