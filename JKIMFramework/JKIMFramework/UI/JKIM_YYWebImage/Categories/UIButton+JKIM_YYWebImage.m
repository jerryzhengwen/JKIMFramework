//
//  UIButton+JKIM_YYWebImage.m
//  JKIM_YYWebImage <https://github.com/ibireme/JKIM_YYWebImage>
//
//  Created by ibireme on 15/2/23.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "UIButton+JKIM_YYWebImage.h"
#import "JKIM_YYWebImageOperation.h"
#import "_JKIM_YYWebImageSetter.h"
#import <objc/runtime.h>

// Dummy class for category
@interface UIButton_JKIM_YYWebImage : NSObject @end
@implementation UIButton_JKIM_YYWebImage @end

static inline NSNumber *UIControlStateSingle(UIControlState state) {
    if (state & UIControlStateHighlighted) return @(UIControlStateHighlighted);
    if (state & UIControlStateDisabled) return @(UIControlStateDisabled);
    if (state & UIControlStateSelected) return @(UIControlStateSelected);
    return @(UIControlStateNormal);
}

static inline NSArray *UIControlStateMulti(UIControlState state) {
    NSMutableArray *array = [NSMutableArray new];
    if (state & UIControlStateHighlighted) [array addObject:@(UIControlStateHighlighted)];
    if (state & UIControlStateDisabled) [array addObject:@(UIControlStateDisabled)];
    if (state & UIControlStateSelected) [array addObject:@(UIControlStateSelected)];
    if ((state & 0xFF) == 0) [array addObject:@(UIControlStateNormal)];
    return array;
}

static int _JKIM_YYWebImageSetterKey;
static int _JKIM_YYWebImageBackgroundSetterKey;


@interface _JKIM_YYWebImageSetterDicForButton : NSObject
- (_JKIM_YYWebImageSetter *)setterForState:(NSNumber *)state;
- (_JKIM_YYWebImageSetter *)lazySetterForState:(NSNumber *)state;
@end

@implementation _JKIM_YYWebImageSetterDicForButton {
    NSMutableDictionary *_dic;
    dispatch_semaphore_t _lock;
}
- (instancetype)init {
    self = [super init];
    _lock = dispatch_semaphore_create(1);
    _dic = [NSMutableDictionary new];
    return self;
}
- (_JKIM_YYWebImageSetter *)setterForState:(NSNumber *)state {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    _JKIM_YYWebImageSetter *setter = _dic[state];
    dispatch_semaphore_signal(_lock);
    return setter;
    
}
- (_JKIM_YYWebImageSetter *)lazySetterForState:(NSNumber *)state {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    _JKIM_YYWebImageSetter *setter = _dic[state];
    if (!setter) {
        setter = [_JKIM_YYWebImageSetter new];
        _dic[state] = setter;
    }
    dispatch_semaphore_signal(_lock);
    return setter;
}
@end


@implementation UIButton (JKIM_YYWebImage)

#pragma mark - image

- (void)_yy_setImageWithURL:(NSURL *)imageURL
             forSingleState:(NSNumber *)state
                placeholder:(UIImage *)placeholder
                    options:(JKIM_YYWebImageOptions)options
                    manager:(JKIM_YYWebImageManager *)manager
                   progress:(JKIM_YYWebImageProgressBlock)progress
                  transform:(JKIM_YYWebImageTransformBlock)transform
                 completion:(JKIM_YYWebImageCompletionBlock)completion {
    if ([imageURL isKindOfClass:[NSString class]]) imageURL = [NSURL URLWithString:(id)imageURL];
    manager = manager ? manager : [JKIM_YYWebImageManager sharedManager];
    
    _JKIM_YYWebImageSetterDicForButton *dic = objc_getAssociatedObject(self, &_JKIM_YYWebImageSetterKey);
    if (!dic) {
        dic = [_JKIM_YYWebImageSetterDicForButton new];
        objc_setAssociatedObject(self, &_JKIM_YYWebImageSetterKey, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    _JKIM_YYWebImageSetter *setter = [dic lazySetterForState:state];
    int32_t sentinel = [setter cancelWithNewURL:imageURL];
    
    _yy_dispatch_sync_on_main_queue(^{
        if (!imageURL) {
            if (!(options & JKIM_YYWebImageOptionIgnorePlaceHolder)) {
                [self setImage:placeholder forState:state.integerValue];
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
                [self setImage:imageFromMemory forState:state.integerValue];
            }
            if(completion) completion(imageFromMemory, imageURL, JKIM_YYWebImageFromMemoryCacheFast, JKIM_YYWebImageStageFinished, nil);
            return;
        }
        
        
        if (!(options & JKIM_YYWebImageOptionIgnorePlaceHolder)) {
            [self setImage:placeholder forState:state.integerValue];
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    BOOL sentinelChanged = weakSetter && weakSetter.sentinel != newSentinel;
                    if (setImage && self && !sentinelChanged) {
                        [self setImage:image forState:state.integerValue];
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

- (void)_yy_cancelImageRequestForSingleState:(NSNumber *)state {
    _JKIM_YYWebImageSetterDicForButton *dic = objc_getAssociatedObject(self, &_JKIM_YYWebImageSetterKey);
    _JKIM_YYWebImageSetter *setter = [dic setterForState:state];
    if (setter) [setter cancel];
}

- (NSURL *)yy_imageURLForState:(UIControlState)state {
    _JKIM_YYWebImageSetterDicForButton *dic = objc_getAssociatedObject(self, &_JKIM_YYWebImageSetterKey);
    _JKIM_YYWebImageSetter *setter = [dic setterForState:UIControlStateSingle(state)];
    return setter.imageURL;
}

- (void)yy_setImageWithURL:(NSURL *)imageURL
                  forState:(UIControlState)state
               placeholder:(UIImage *)placeholder {
    [self yy_setImageWithURL:imageURL
                 forState:state
              placeholder:placeholder
                  options:kNilOptions
                  manager:nil
                 progress:nil
                transform:nil
               completion:nil];
}

- (void)yy_setImageWithURL:(NSURL *)imageURL
                  forState:(UIControlState)state
                   options:(JKIM_YYWebImageOptions)options {
    [self yy_setImageWithURL:imageURL
                    forState:state
                 placeholder:nil
                     options:options
                     manager:nil
                    progress:nil
                   transform:nil
                  completion:nil];
}

- (void)yy_setImageWithURL:(NSURL *)imageURL
                  forState:(UIControlState)state
               placeholder:(UIImage *)placeholder
                   options:(JKIM_YYWebImageOptions)options
                completion:(JKIM_YYWebImageCompletionBlock)completion {
    [self yy_setImageWithURL:imageURL
                    forState:state
                 placeholder:placeholder
                     options:options
                     manager:nil
                    progress:nil
                   transform:nil
                  completion:completion];
}

- (void)yy_setImageWithURL:(NSURL *)imageURL
                  forState:(UIControlState)state
               placeholder:(UIImage *)placeholder
                   options:(JKIM_YYWebImageOptions)options
                  progress:(JKIM_YYWebImageProgressBlock)progress
                 transform:(JKIM_YYWebImageTransformBlock)transform
                completion:(JKIM_YYWebImageCompletionBlock)completion {
    [self yy_setImageWithURL:imageURL
                    forState:state
                 placeholder:placeholder
                     options:options
                     manager:nil
                    progress:progress
                   transform:transform
                  completion:completion];
}

- (void)yy_setImageWithURL:(NSURL *)imageURL
                  forState:(UIControlState)state
               placeholder:(UIImage *)placeholder
                   options:(JKIM_YYWebImageOptions)options
                   manager:(JKIM_YYWebImageManager *)manager
                  progress:(JKIM_YYWebImageProgressBlock)progress
                 transform:(JKIM_YYWebImageTransformBlock)transform
                completion:(JKIM_YYWebImageCompletionBlock)completion {
    for (NSNumber *num in UIControlStateMulti(state)) {
        [self _yy_setImageWithURL:imageURL
                   forSingleState:num
                      placeholder:placeholder
                          options:options
                          manager:manager
                         progress:progress
                        transform:transform
                       completion:completion];
    }
}

- (void)yy_cancelImageRequestForState:(UIControlState)state {
    for (NSNumber *num in UIControlStateMulti(state)) {
        [self _yy_cancelImageRequestForSingleState:num];
    }
}


#pragma mark - background image

- (void)_yy_setBackgroundImageWithURL:(NSURL *)imageURL
                       forSingleState:(NSNumber *)state
                          placeholder:(UIImage *)placeholder
                              options:(JKIM_YYWebImageOptions)options
                              manager:(JKIM_YYWebImageManager *)manager
                             progress:(JKIM_YYWebImageProgressBlock)progress
                            transform:(JKIM_YYWebImageTransformBlock)transform
                           completion:(JKIM_YYWebImageCompletionBlock)completion {
    if ([imageURL isKindOfClass:[NSString class]]) imageURL = [NSURL URLWithString:(id)imageURL];
    manager = manager ? manager : [JKIM_YYWebImageManager sharedManager];
    
    _JKIM_YYWebImageSetterDicForButton *dic = objc_getAssociatedObject(self, &_JKIM_YYWebImageBackgroundSetterKey);
    if (!dic) {
        dic = [_JKIM_YYWebImageSetterDicForButton new];
        objc_setAssociatedObject(self, &_JKIM_YYWebImageBackgroundSetterKey, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    _JKIM_YYWebImageSetter *setter = [dic lazySetterForState:state];
    int32_t sentinel = [setter cancelWithNewURL:imageURL];
    
    _yy_dispatch_sync_on_main_queue(^{
        if (!imageURL) {
            if (!(options & JKIM_YYWebImageOptionIgnorePlaceHolder)) {
                [self setBackgroundImage:placeholder forState:state.integerValue];
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
                [self setBackgroundImage:imageFromMemory forState:state.integerValue];
            }
            if(completion) completion(imageFromMemory, imageURL, JKIM_YYWebImageFromMemoryCacheFast, JKIM_YYWebImageStageFinished, nil);
            return;
        }
        
        
        if (!(options & JKIM_YYWebImageOptionIgnorePlaceHolder)) {
            [self setBackgroundImage:placeholder forState:state.integerValue];
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    BOOL sentinelChanged = weakSetter && weakSetter.sentinel != newSentinel;
                    if (setImage && self && !sentinelChanged) {
                        [self setBackgroundImage:image forState:state.integerValue];
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

- (void)_yy_cancelBackgroundImageRequestForSingleState:(NSNumber *)state {
    _JKIM_YYWebImageSetterDicForButton *dic = objc_getAssociatedObject(self, &_JKIM_YYWebImageBackgroundSetterKey);
    _JKIM_YYWebImageSetter *setter = [dic setterForState:state];
    if (setter) [setter cancel];
}

- (NSURL *)yy_backgroundImageURLForState:(UIControlState)state {
    _JKIM_YYWebImageSetterDicForButton *dic = objc_getAssociatedObject(self, &_JKIM_YYWebImageBackgroundSetterKey);
    _JKIM_YYWebImageSetter *setter = [dic setterForState:UIControlStateSingle(state)];
    return setter.imageURL;
}

- (void)yy_setBackgroundImageWithURL:(NSURL *)imageURL
                            forState:(UIControlState)state
                         placeholder:(UIImage *)placeholder {
    [self yy_setBackgroundImageWithURL:imageURL
                              forState:state
                           placeholder:placeholder
                               options:kNilOptions
                               manager:nil
                              progress:nil
                             transform:nil
                            completion:nil];
}

- (void)yy_setBackgroundImageWithURL:(NSURL *)imageURL
                            forState:(UIControlState)state
                             options:(JKIM_YYWebImageOptions)options {
    [self yy_setBackgroundImageWithURL:imageURL
                              forState:state
                           placeholder:nil
                               options:options
                               manager:nil
                              progress:nil
                             transform:nil
                            completion:nil];
}

- (void)yy_setBackgroundImageWithURL:(NSURL *)imageURL
                            forState:(UIControlState)state
                         placeholder:(UIImage *)placeholder
                             options:(JKIM_YYWebImageOptions)options
                          completion:(JKIM_YYWebImageCompletionBlock)completion {
    [self yy_setBackgroundImageWithURL:imageURL
                              forState:state
                           placeholder:placeholder
                               options:options
                               manager:nil
                              progress:nil
                             transform:nil
                            completion:completion];
}

- (void)yy_setBackgroundImageWithURL:(NSURL *)imageURL
                            forState:(UIControlState)state
                         placeholder:(UIImage *)placeholder
                             options:(JKIM_YYWebImageOptions)options
                            progress:(JKIM_YYWebImageProgressBlock)progress
                           transform:(JKIM_YYWebImageTransformBlock)transform
                          completion:(JKIM_YYWebImageCompletionBlock)completion {
    [self yy_setBackgroundImageWithURL:imageURL
                              forState:state
                           placeholder:placeholder
                               options:options
                               manager:nil
                              progress:progress
                             transform:transform
                            completion:completion];
}

- (void)yy_setBackgroundImageWithURL:(NSURL *)imageURL
                            forState:(UIControlState)state
                         placeholder:(UIImage *)placeholder
                             options:(JKIM_YYWebImageOptions)options
                             manager:(JKIM_YYWebImageManager *)manager
                            progress:(JKIM_YYWebImageProgressBlock)progress
                           transform:(JKIM_YYWebImageTransformBlock)transform
                          completion:(JKIM_YYWebImageCompletionBlock)completion {
    for (NSNumber *num in UIControlStateMulti(state)) {
        [self _yy_setBackgroundImageWithURL:imageURL
                             forSingleState:num
                                placeholder:placeholder
                                    options:options
                                    manager:manager
                                   progress:progress
                                  transform:transform
                                 completion:completion];
    }
}

- (void)yy_cancelBackgroundImageRequestForState:(UIControlState)state {
    for (NSNumber *num in UIControlStateMulti(state)) {
        [self _yy_cancelBackgroundImageRequestForSingleState:num];
    }
}

@end
