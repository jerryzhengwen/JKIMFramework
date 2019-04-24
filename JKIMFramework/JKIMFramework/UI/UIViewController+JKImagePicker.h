//
//  UIViewController+JKImagePicker.h
//  JKIMSDKProject
//
//  Created by zzx on 2019/4/2.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ImagePickerCompletionHandler)(NSData *imageData, UIImage *image);


@interface UIViewController (JKImagePicker)
/**
 选择了相册
 */
- (void)presentChosePhotoAlbumWithCompletionHandler:(ImagePickerCompletionHandler)completionHandler;
    
/**
 选择了相机
 */
- (void)presentChoseCameraWithCompletionHandler:(ImagePickerCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
