//
//  UIButton+YYWebImage.h
//  YYWebImage <https://github.com/ibireme/YYWebImage>
//
//  Created by ibireme on 15/2/23.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>
#import "JK_YYWebImageManager.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Web image methods for UIButton.
 */
@interface UIButton (JK_YYWebImage)

#pragma mark - image

/**
 Current image URL for the specified state.
 @return The image URL, or nil.
 */
- (nullable NSURL *)yy_imageURLForState:(UIControlState)state;

/**
 Set the button's image with a specified URL for the specified state.
 
 @param imageURL    The image url (remote or local file path).
 @param state       The state that uses the specified image.
 @param placeholder The image to be set initially, until the image request finishes.
 */
- (void)yy_setImageWithURL:(nullable NSURL *)imageURL
                  forState:(UIControlState)state
               placeholder:(nullable UIImage *)placeholder;

/**
 Set the button's image with a specified URL for the specified state.
 
 @param imageURL The image url (remote or local file path).
 @param state    The state that uses the specified image.
 @param options  The options to use when request the image.
 */
- (void)yy_setImageWithURL:(nullable NSURL *)imageURL
                  forState:(UIControlState)state
                   options:(JK_YYWebImageOptions)options;

/**
 Set the button's image with a specified URL for the specified state.
 
 @param imageURL    The image url (remote or local file path).
 @param state       The state that uses the specified image.
 @param placeholder The image to be set initially, until the image request finishes.
 @param options     The options to use when request the image.
 @param completion  The block invoked (on main thread) when image request completed.
 */
- (void)yy_setImageWithURL:(nullable NSURL *)imageURL
                  forState:(UIControlState)state
               placeholder:(nullable UIImage *)placeholder
                   options:(JK_YYWebImageOptions)options
                completion:(nullable JK_YYWebImageCompletionBlock)completion;

/**
 Set the button's image with a specified URL for the specified state.
 
 @param imageURL    The image url (remote or local file path).
 @param state       The state that uses the specified image.
 @param placeholder The image to be set initially, until the image request finishes.
 @param options     The options to use when request the image.
 @param progress    The block invoked (on main thread) during image request.
 @param transform   The block invoked (on background thread) to do additional image process.
 @param completion  The block invoked (on main thread) when image request completed.
 */
- (void)yy_setImageWithURL:(nullable NSURL *)imageURL
                  forState:(UIControlState)state
               placeholder:(nullable UIImage *)placeholder
                   options:(JK_YYWebImageOptions)options
                  progress:(nullable JK_YYWebImageProgressBlock)progress
                 transform:(nullable JK_YYWebImageTransformBlock)transform
                completion:(nullable JK_YYWebImageCompletionBlock)completion;

/**
 Set the button's image with a specified URL for the specified state.
 
 @param imageURL    The image url (remote or local file path).
 @param state       The state that uses the specified image.
 @param placeholder The image to be set initially, until the image request finishes.
 @param options     The options to use when request the image.
 @param manager     The manager to create image request operation.
 @param progress    The block invoked (on main thread) during image request.
 @param transform   The block invoked (on background thread) to do additional image process.
 @param completion  The block invoked (on main thread) when image request completed.
 */
- (void)yy_setImageWithURL:(nullable NSURL *)imageURL
                  forState:(UIControlState)state
               placeholder:(nullable UIImage *)placeholder
                   options:(JK_YYWebImageOptions)options
                   manager:(nullable JK_YYWebImageManager *)manager
                  progress:(nullable JK_YYWebImageProgressBlock)progress
                 transform:(nullable JK_YYWebImageTransformBlock)transform
                completion:(nullable JK_YYWebImageCompletionBlock)completion;

/**
 Cancel the current image request for a specified state.
 @param state The state that uses the specified image.
 */
- (void)yy_cancelImageRequestForState:(UIControlState)state;



#pragma mark - background image

/**
 Current backgroundImage URL for the specified state.
 @return The image URL, or nil.
 */
- (nullable NSURL *)yy_backgroundImageURLForState:(UIControlState)state;

/**
 Set the button's backgroundImage with a specified URL for the specified state.
 
 @param imageURL    The image url (remote or local file path).
 @param state       The state that uses the specified image.
 @param placeholder The image to be set initially, until the image request finishes.
 */
- (void)yy_setBackgroundImageWithURL:(nullable NSURL *)imageURL
                            forState:(UIControlState)state
                         placeholder:(nullable UIImage *)placeholder;

/**
 Set the button's backgroundImage with a specified URL for the specified state.
 
 @param imageURL The image url (remote or local file path).
 @param state    The state that uses the specified image.
 @param options  The options to use when request the image.
 */
- (void)yy_setBackgroundImageWithURL:(nullable NSURL *)imageURL
                            forState:(UIControlState)state
                             options:(JK_YYWebImageOptions)options;

/**
 Set the button's backgroundImage with a specified URL for the specified state.
 
 @param imageURL    The image url (remote or local file path).
 @param state       The state that uses the specified image.
 @param placeholder The image to be set initially, until the image request finishes.
 @param options     The options to use when request the image.
 @param completion  The block invoked (on main thread) when image request completed.
 */
- (void)yy_setBackgroundImageWithURL:(nullable NSURL *)imageURL
                            forState:(UIControlState)state
                         placeholder:(nullable UIImage *)placeholder
                             options:(JK_YYWebImageOptions)options
                          completion:(nullable JK_YYWebImageCompletionBlock)completion;

/**
 Set the button's backgroundImage with a specified URL for the specified state.
 
 @param imageURL    The image url (remote or local file path).
 @param state       The state that uses the specified image.
 @param placeholder The image to be set initially, until the image request finishes.
 @param options     The options to use when request the image.
 @param progress    The block invoked (on main thread) during image request.
 @param transform   The block invoked (on background thread) to do additional image process.
 @param completion  The block invoked (on main thread) when image request completed.
 */
- (void)yy_setBackgroundImageWithURL:(nullable NSURL *)imageURL
                            forState:(UIControlState)state
                         placeholder:(nullable UIImage *)placeholder
                             options:(JK_YYWebImageOptions)options
                            progress:(nullable JK_YYWebImageProgressBlock)progress
                           transform:(nullable JK_YYWebImageTransformBlock)transform
                          completion:(nullable JK_YYWebImageCompletionBlock)completion;

/**
 Set the button's backgroundImage with a specified URL for the specified state.
 
 @param imageURL    The image url (remote or local file path).
 @param state       The state that uses the specified image.
 @param placeholder The image to be set initially, until the image request finishes.
 @param options     The options to use when request the image.
 @param manager     The manager to create image request operation.
 @param progress    The block invoked (on main thread) during image request.
 @param transform   The block invoked (on background thread) to do additional image process.
 @param completion  The block invoked (on main thread) when image request completed.
 */
- (void)yy_setBackgroundImageWithURL:(nullable NSURL *)imageURL
                            forState:(UIControlState)state
                         placeholder:(nullable UIImage *)placeholder
                             options:(JK_YYWebImageOptions)options
                             manager:(nullable JK_YYWebImageManager *)manager
                            progress:(nullable JK_YYWebImageProgressBlock)progress
                           transform:(nullable JK_YYWebImageTransformBlock)transform
                          completion:(nullable JK_YYWebImageCompletionBlock)completion;

/**
 Cancel the current backgroundImage request for a specified state.
 @param state The state that uses the specified image.
 */
- (void)yy_cancelBackgroundImageRequestForState:(UIControlState)state;

@end

NS_ASSUME_NONNULL_END
