//
//  JKIM_YYImage.h
//  JKIM_YYImage <https://github.com/ibireme/JKIM_YYImage>
//
//  Created by ibireme on 14/10/20.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

#if __has_include(<JKIM_YYImage/JKIM_YYImage.h>)
FOUNDATION_EXPORT double JKIM_YYImageVersionNumber;
FOUNDATION_EXPORT const unsigned char JKIM_YYImageVersionString[];
#import <JKIM_YYImage/JKIM_YYFrameImage.h>
#import <JKIM_YYImage/JKIM_YYSpriteSheetImage.h>
#import <JKIM_YYImage/JKIM_YYImageCoder.h>
#import <JKIM_YYImage/JKIM_YYAnimatedImageView.h>
#elif __has_include(<JKIM_YYWebImage/JKIM_YYImage.h>)
#import <JKIM_YYWebImage/JKIM_YYFrameImage.h>
#import <JKIM_YYWebImage/JKIM_YYSpriteSheetImage.h>
#import <JKIM_YYWebImage/JKIM_YYImageCoder.h>
#import <JKIM_YYWebImage/JKIM_YYAnimatedImageView.h>
#else
#import "JKIM_YYFrameImage.h"
#import "JKIM_YYSpriteSheetImage.h"
#import "JKIM_YYImageCoder.h"
#import "JKIM_YYAnimatedImageView.h"
#endif

NS_ASSUME_NONNULL_BEGIN


/**
 A JKIM_YYImage object is a high-level way to display animated image data.
 
 @discussion It is a fully compatible `UIImage` subclass. It extends the UIImage
 to support animated WebP, APNG and GIF format image data decoding. It also 
 support NSCoding protocol to archive and unarchive multi-frame image data.
 
 If the image is created from multi-frame image data, and you want to play the 
 animation, try replace UIImageView with `JKIM_YYAnimatedImageView`.
 
 Sample Code:
 
     // animation@3x.webp
     JKIM_YYImage *image = [JKIM_YYImage imageNamed:@"animation.webp"];
     JKIM_YYAnimatedImageView *imageView = [JKIM_YYAnimatedImageView alloc] initWithImage:image];
     [view addSubView:imageView];
    
 */
@interface JKIM_YYImage : UIImage <JKIM_YYAnimatedImage>

+ (nullable JKIM_YYImage *)imageNamed:(NSString *)name; // no cache!
+ (nullable JKIM_YYImage *)imageWithContentsOfFile:(NSString *)path;
+ (nullable JKIM_YYImage *)imageWithData:(NSData *)data;
+ (nullable JKIM_YYImage *)imageWithData:(NSData *)data scale:(CGFloat)scale;

/**
 If the image is created from data or file, then the value indicates the data type.
 */
@property (nonatomic, readonly) JKIM_YYImageType animatedImageType;

/**
 If the image is created from animated image data (multi-frame GIF/APNG/WebP),
 this property stores the original image data.
 */
@property (nullable, nonatomic, readonly) NSData *animatedImageData;

/**
 The total memory usage (in bytes) if all frame images was loaded into memory.
 The value is 0 if the image is not created from a multi-frame image data.
 */
@property (nonatomic, readonly) NSUInteger animatedImageMemorySize;

/**
 Preload all frame image to memory.
 
 @discussion Set this property to `YES` will block the calling thread to decode 
 all animation frame image to memory, set to `NO` will release the preloaded frames.
 If the image is shared by lots of image views (such as emoticon), preload all
 frames will reduce the CPU cost.
 
 See `animatedImageMemorySize` for memory cost.
 */
@property (nonatomic) BOOL preloadAllAnimatedImageFrames;

@end

NS_ASSUME_NONNULL_END
