//
//  JKIMSendHelp.m
//  JKIMSDKProject
//
//  Created by zzx on 2019/4/24.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKIMSendHelp.h"
#import "JKDialogModel.h"
#import "JKMessageFrame.h"
#import "JKDialogueHeader.h"
#import "JKConnectCenter.h"
#import "RegexKitLite.h"
#import "YYWebImage.h"
@implementation JKIMSendHelp



/**
 发送文本信息
 @param messageModel 至少包含一下几个信息
        isRichText、content、msgSendType、whoSend、roomId、chatId

 @param completeBlock 完成的回调
 */
+ (void)sendTextMessageWithMessageModel:(JKMessage *)messageModel completeBlock:(CompleteBlock)completeBlock{
    JKMessageFrame *frameModel = [[JKMessageFrame alloc]init];
    messageModel.messageId = [NSUUID UUID].UUIDString;
    messageModel.time = [JKIMSendHelp jk_getTimestamp];
    NSString * imgContent = messageModel.content;
    NSString *emotion = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
    NSArray *cmps = [messageModel.content componentsMatchedByRegex:emotion];
    if (cmps.count) {
        NSString *filePath = [JKBundleTool initBundlePathWithResouceName:@"JKFace" type:@"plist"];
        NSArray  *face = [NSArray arrayWithContentsOfFile:filePath];
        for (NSString *obj in cmps) {
            for (int i =0; i <face.count; i ++) {
                if ([face[i][@"face_name"] isEqualToString:obj]) {
                    imgContent = [imgContent stringByReplacingOccurrencesOfString:obj withString:face[i][@"face_send"]];
                }
            }
        }
    }
    messageModel.sendContent = imgContent;
    JKDialogModel * model = [JKDialogModel changeMsgTypeWithJKModel:messageModel];
    frameModel.message = model;
    if (completeBlock) {
        completeBlock(frameModel);
    }
    //在这里判断下model 中是否包含表情  获取业务类型的时候不需要调用
    if (messageModel.to.length) {
        [[JKConnectCenter sharedJKConnectCenter]sendMessage:messageModel];
    }
}
+(void)judgeNetThenSendTextMessageWithMessageModel:(JKMessage *)messageModel{
    if (messageModel.to.length) {
        [[JKConnectCenter sharedJKConnectCenter]sendMessage:messageModel];
    }else{
        [[JKConnectCenter sharedJKConnectCenter]sendRobotMessage:messageModel firstReNeedBlock:nil withRobotMessageBlock:nil AndReutrnMessageStatusBlock:nil];
    }
}

+ (void)sendImageMessageWithImageData:(NSData *)imageData image:(UIImage *)image MessageModel:(JKMessage *)messageModel completeBlock:(CompleteBlock)completeBlock{
    
//    JKDialogModel * model = [JKDialogModel alloc];
    JKMessageFrame *frameModel = [[JKMessageFrame alloc]init];
    messageModel.whoSend = JK_Visitor;
    messageModel.isRichText = NO;
    messageModel.msgSendType = JK_SocketMSG;
    messageModel.imageData = imageData;
    messageModel.messageType = JKMessageImage;
    messageModel.time = [JKIMSendHelp jk_getTimestamp];
    
    NSMutableArray *sizeArr = [UIView returnImageViewWidthAndHeightWith:[NSString stringWithFormat:@"%lf",image.size.width] AndHeight:[NSString stringWithFormat:@"%lf",image.size.height]];
    
    messageModel.imageWidth  = [[sizeArr objectAtIndex:0] floatValue];
    messageModel.imageHeight = [[sizeArr objectAtIndex:1] floatValue];
    //获取图片的格式
    YYImageType imageType = YYImageDetectType((__bridge CFDataRef)imageData);
    
    NSString *photoPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    if (imageType == YYImageTypeJPEG || imageType == YYImageTypePNG || imageType == YYImageTypeJPEG2000) {
        photoPath = [photoPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",messageModel.time]];
    }else if(imageType == YYImageTypeGIF) {
        photoPath = [photoPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.gif",messageModel.time]];
    }
    
    [imageData writeToFile:photoPath atomically:YES];
    
    messageModel.content = photoPath;
    [[JKConnectCenter sharedJKConnectCenter]sendMessage:messageModel];
    JKDialogModel * model = [JKDialogModel changeMsgTypeWithJKModel:messageModel];
    frameModel.message = model;
    if (completeBlock) {
        completeBlock(frameModel);
    }
}

/**
 获取时间戳
 
 @return 当前的时间戳
 */
+ (NSString *)jk_getTimestamp {
    NSDate *now = [NSDate date];
    NSTimeInterval tempTime = [now timeIntervalSince1970]*1000;
    NSInteger timestamp = [[NSString stringWithFormat:@"%.f",tempTime] doubleValue];
    return [NSString stringWithFormat:@"%zd",timestamp];
}

@end
