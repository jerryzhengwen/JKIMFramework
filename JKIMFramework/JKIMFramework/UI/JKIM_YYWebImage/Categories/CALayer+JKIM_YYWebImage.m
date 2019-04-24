//
//  CALayer+JKIM_YYWebImage.m
//  JKIM_YYWebImage <https://github.com/ibireme/JKIM_YYWebImage>
//
//  Created by ibireme on 15/2/23.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "CALayer+JKIM_YYWebImage.h"
#import "JKIM_YYWebImageOperation.h"
#import "_JKIM_YYWebImageSetter.h"
#import <objc/runtime.h>

// Dummy class for category
@interface CALayer_JKIM_YYWebImage : NSObject @end
@implementation CALayer_JKIM_YYWebImage @end


static int _JKIM_YYWebImageSetterKey;

@implementation CALayer (JKIM_YYWebImage)

- (NSURL *)yy_imageURL {
    _JKIM_YYWebImageSetter *setter = objc_getAssociatedObject(self, &_JKIM_YYWebImageSetterKey);
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

- (void)yy_setImageWithURL:(NSURL *)imageURL options:(JKIM_YYWebImageOptions)options {
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
                   options:(JKIM_YYWebImageOptions)options
                completion:(JKIM_YYWebImageCompletionBlock)completion {
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
                   options:(JKIM_YYWebImageOptions)options
                  progress:(JKIM_YYWebImageProgressBlock)progress
                 transform:(JKIM_YYWebImageTransformBlock)transform
                completion:(JKIM_YYWebImageCompletionBlock)completion {
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
                   options:(JKIM_YYWebImageOptions)options
                   manager:(JKIM_YYWebImageManager *)manager
                  progress:(JKIM_YYWebImageProgressBlock)progress
                 transform:(JKIM_YYWebImageTransformBlock)transform
                completion:(JKIM_YYWebImageCompletionBlock)completion {
    if ([imageURL isKindOfClass:[NSString class]]) imageURL = [NSURL URLWithString:(id)imageURL];
    manager = manager ? manager : [JKIM_YYWebImageManager sharedManager];
    
    
    _JKIM_YYWebImageSetter *setter = objc_getAssociatedObject(self, &_JKIM_YYWebImageSetterKey);
    if (!setter) {
        setter = [_JKIM_YYWebImageSetter new];
        objc_setAssociatedObject(self, &_JKIM_YYWebImageSetterKey, setter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    int32_t sentinel = [setter cancelWithNewURL:imageURL];
    
    _yy_dispatch_sync_on_main_queue(^{
        if ((options & JKIM_YYWebImageOptionSetImageWithFadeAnimation) &&
            !(options & JKIM_YYWebImageOptionAvoidSetImage)) {
            [self removeAnimationForKey:_JKIM_YYWebImageFadeAnimationKey];
        }
        
        if (!imageURL) {
            if (!(options & JKIM_YYWebImageOptionIgnorePlaceHolder)) {
                self.contents = (id)placeholder.CGImage;
            }
            return;
        }
        
        // get the image from memory as quickly as possible
        UIImage *imageFromMemory = nil;
        if (manager.cache &&
            !(options & JKIM_YYWebImageOptionUseNSURLCache) &&
            !(options & JKIM_YYWebImageOptionRefreshImageCache)) {
            imageFromMemory = [manager.cache getImageForKey:[manager cacheKeyForURL:imageURL] withType:JKIM_YYImageCacheTypeMemory];
        }
        if (imageFromMemory) {
            if (!(options & JKIM_YYWebImageOptionAvoidSetImage)) {
                self.contents = (id)imageFromMemory.CGImage;
            }
            if(completion) completion(imageFromMemory, imageURL, JKIM_YYWebImageFromMemoryCacheFast, JKIM_YYWebImageStageFinished, nil);
            return;
        }
        
        if (!(options & JKIM_YYWebImageOptionIgnorePlaceHolder)) {
            self.contents = (id)placeholder.CGImage;
        }
        
        __weak typeof(self) _self = self;
        dispatch_async([_JKIM_YYWebImageSetter setterQueue], ^{
            JKIM_YYWebImageProgressBlock _progress = nil;
            if (progress) _progress = ^(NSInteger receivedSize, NSInteger expectedSize) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    progress(receivedSize, expectedSize);
                });
            };
            
            __block int32_t newSentinel = 0;
            __block __weak typeof(setter) weakSetter = nil;
            JKIM_YYWebImageCompletionBlock _completion = ^(UIImage *image, NSURL *url, JKIM_YYWebImageFromType from, JKIM_YYWebImageStage stage, NSError *error) {
                __strong typeof(_self) self = _self;
                BOOL setImage = (stage == JKIM_YYWebImageStageFinished || stage == JKIM_YYWebImageStageProgress) && image && !(options & JKIM_YYWebImageOptionAvoidSetImage);
                BOOL showFade = (options & JKIM_YYWebImageOptionSetImageWithFadeAnimation);
                dispatch_async(dispatch_get_main_queue(), ^{
                    BOOL sentinelChanged = weakSetter && weakSetter.sentinel != newSentinel;
                    if (setImage && self && !sentinelChanged) {
                        if (showFade) {
                            CATransition *transition = [CATransition animation];
                            transition.duration = stage == JKIM_YYWebImageStageFinished ? _JKIM_YYWebImageFadeTime : _JKIM_YYWebImageProgressiveFadeTime;
                            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                            transition.type = kCATransitionFade;
                            [self addAnimation:transition forKey:_JKIM_YYWebImageFadeAnimationKey];
                        }
                        self.contents = (id)image.CGImage;
                    }
                    if (completion) {
                        if (sentinelChanged) {
                            completion(nil, url, JKIM_YYWebImageFromNone, JKIM_YYWebImageStageCancelled, nil);
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
    _JKIM_YYWebImageSetter *setter = objc_getAssociatedObject(self, &_JKIM_YYWebImageSetterKey);
    if (setter) [setter cancel];
}

@end
