//
//  CALayer+YYWebImage.m
//  YYWebImage <https://github.com/ibireme/YYWebImage>
//
//  Created by ibireme on 15/2/23.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "CALayer+JK_YYWebImage.h"
#import "JK_YYWebImageOperation.h"
#import "JK_YYWebImageSetter.h"
#import <objc/runtime.h>

// Dummy class for category
@interface JK_CALayer_YYWebImage : NSObject @end
@implementation JK_CALayer_YYWebImage @end


static int JK_YYWebImageSetterKey;

@implementation CALayer (JK_YYWebImage)

- (NSURL *)yy_imageURL {
    JK_YYWebImageSetter *setter = objc_getAssociatedObject(self, &JK_YYWebImageSetterKey);
    return setter.imageURL;
}

- (void)setYy_imageURL:(NSURL *)imageURL {
    [self yy_setImageWithURL:imageURL
              placeholder:nil
                  options:kNilOptions
                  manager:nil
                 progress:nil
                transform:nil
               completion:nil];
}

- (void)yy_setImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder {
    [self yy_setImageWithURL:imageURL
                 placeholder:placeholder
                     options:kNilOptions
                     manager:nil
                    progress:nil
                   transform:nil
                  completion:nil];
}

- (void)yy_setImageWithURL:(NSURL *)imageURL options:(JK_YYWebImageOptions)options {
    [self yy_setImageWithURL:imageURL
                 placeholder:nil
                     options:options
                     manager:nil
                    progress:nil
                   transform:nil
                  completion:nil];
}

- (void)yy_setImageWithURL:(NSURL *)imageURL
               placeholder:(UIImage *)placeholder
                   options:(JK_YYWebImageOptions)options
                completion:(JK_YYWebImageCompletionBlock)completion {
    [self yy_setImageWithURL:imageURL
                 placeholder:placeholder
                     options:options
                     manager:nil
                    progress:nil
                   transform:nil
                  completion:completion];
}

- (void)yy_setImageWithURL:(NSURL *)imageURL
               placeholder:(UIImage *)placeholder
                   options:(JK_YYWebImageOptions)options
                  progress:(JK_YYWebImageProgressBlock)progress
                 transform:(JK_YYWebImageTransformBlock)transform
                completion:(JK_YYWebImageCompletionBlock)completion {
    [self yy_setImageWithURL:imageURL
                 placeholder:placeholder
                     options:options
                     manager:nil
                    progress:progress
                   transform:transform
                  completion:completion];
}

- (void)yy_setImageWithURL:(NSURL *)imageURL
               placeholder:(UIImage *)placeholder
                   options:(JK_YYWebImageOptions)options
                   manager:(JK_YYWebImageManager *)manager
                  progress:(JK_YYWebImageProgressBlock)progress
                 transform:(JK_YYWebImageTransformBlock)transform
                completion:(JK_YYWebImageCompletionBlock)completion {
    if ([imageURL isKindOfClass:[NSString class]]) imageURL = [NSURL URLWithString:(id)imageURL];
    manager = manager ? manager : [JK_YYWebImageManager sharedManager];
    
    
    JK_YYWebImageSetter *setter = objc_getAssociatedObject(self, &JK_YYWebImageSetterKey);
    if (!setter) {
        setter = [JK_YYWebImageSetter new];
        objc_setAssociatedObject(self, &JK_YYWebImageSetterKey, setter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    int32_t sentinel = [setter cancelWithNewURL:imageURL];
    
    _JK_yy_dispatch_sync_on_main_queue(^{
        if ((options & JK_YYWebImageOptionSetImageWithFadeAnimation) &&
            !(options & JK_YYWebImageOptionAvoidSetImage)) {
            [self removeAnimationForKey:JK_YYWebImageFadeAnimationKey];
        }
        
        if (!imageURL) {
            if (!(options & JK_YYWebImageOptionIgnorePlaceHolder)) {
                self.contents = (id)placeholder.CGImage;
            }
            return;
        }
        
        // get the image from memory as quickly as possible
        UIImage *imageFromMemory = nil;
        if (manager.cache &&
            !(options & JK_YYWebImageOptionUseNSURLCache) &&
            !(options & JK_YYWebImageOptionRefreshImageCache)) {
            imageFromMemory = [manager.cache getImageForKey:[manager cacheKeyForURL:imageURL] withType:JK_YYImageCacheTypeMemory];
        }
        if (imageFromMemory) {
            if (!(options & JK_YYWebImageOptionAvoidSetImage)) {
                self.contents = (id)imageFromMemory.CGImage;
            }
            if(completion) completion(imageFromMemory, imageURL, JK_YYWebImageFromMemoryCacheFast, JK_YYWebImageStageFinished, nil);
            return;
        }
        
        if (!(options & JK_YYWebImageOptionIgnorePlaceHolder)) {
            self.contents = (id)placeholder.CGImage;
        }
        
        __weak typeof(self) _self = self;
        dispatch_async([JK_YYWebImageSetter setterQueue], ^{
            JK_YYWebImageProgressBlock _progress = nil;
            if (progress) _progress = ^(NSInteger receivedSize, NSInteger expectedSize) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    progress(receivedSize, expectedSize);
                });
            };
            
            __block int32_t newSentinel = 0;
            __block __weak typeof(setter) weakSetter = nil;
            JK_YYWebImageCompletionBlock _completion = ^(UIImage *image, NSURL *url, JK_YYWebImageFromType from, JK_YYWebImageStage stage, NSError *error) {
                __strong typeof(_self) self = _self;
                BOOL setImage = (stage == JK_YYWebImageStageFinished || stage == JK_YYWebImageStageProgress) && image && !(options & JK_YYWebImageOptionAvoidSetImage);
                BOOL showFade = (options & JK_YYWebImageOptionSetImageWithFadeAnimation);
                dispatch_async(dispatch_get_main_queue(), ^{
                    BOOL sentinelChanged = weakSetter && weakSetter.sentinel != newSentinel;
                    if (setImage && self && !sentinelChanged) {
                        if (showFade) {
                            CATransition *transition = [CATransition animation];
                            transition.duration = stage == JK_YYWebImageStageFinished ? JK_YYWebImageFadeTime : JK_YYWebImageProgressiveFadeTime;
                            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                            transition.type = kCATransitionFade;
                            [self addAnimation:transition forKey:JK_YYWebImageFadeAnimationKey];
                        }
                        self.contents = (id)image.CGImage;
                    }
                    if (completion) {
                        if (sentinelChanged) {
                            completion(nil, url, JK_YYWebImageFromNone, JK_YYWebImageStageCancelled, nil);
                        } else {
                            completion(image, url, from, stage, error);
                        }
                    }
                });
            };
            
            newSentinel = [setter setOperationWithSentinel:sentinel url:imageURL options:options manager:manager progress:_progress transform:transform completion:_completion];
            weakSetter = setter;
        });
        
        
    });
}

- (void)yy_cancelCurrentImageRequest {
    JK_YYWebImageSetter *setter = objc_getAssociatedObject(self, &JK_YYWebImageSetterKey);
    if (setter) [setter cancel];
}

@end
