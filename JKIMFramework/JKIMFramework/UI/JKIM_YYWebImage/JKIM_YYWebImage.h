//
//  JKIM_YYWebImage.h
//  JKIM_YYWebImage <https://github.com/ibireme/JKIM_YYWebImage>
//
//  Created by ibireme on 15/2/23.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

#if __has_include(<JKIM_YYWebImage/JKIM_YYWebImage.h>)
FOUNDATION_EXPORT double JKIM_YYWebImageVersionNumber;
FOUNDATION_EXPORT const unsigned char JKIM_YYWebImageVersionString[];
#import <JKIM_YYWebImage/JKIM_YYImageCache.h>
#import <JKIM_YYWebImage/JKIM_YYWebImageOperation.h>
#import <JKIM_YYWebImage/JKIM_YYWebImageManager.h>
#import <JKIM_YYWebImage/UIImage+JKIM_YYWebImage.h>
#import <JKIM_YYWebImage/UIImageView+JKIM_YYWebImage.h>
#import <JKIM_YYWebImage/UIButton+JKIM_YYWebImage.h>
#import <JKIM_YYWebImage/CALayer+JKIM_YYWebImage.h>
#import <JKIM_YYWebImage/MKAnnotationView+JKIM_YYWebImage.h>
#else
#import "JKIM_YYImageCache.h"
#import "JKIM_YYWebImageOperation.h"
#import "JKIM_YYWebImageManager.h"
#import "UIImage+JKIM_YYWebImage.h"
#import "UIImageView+JKIM_YYWebImage.h"
#import "UIButton+JKIM_YYWebImage.h"
#import "CALayer+JKIM_YYWebImage.h"
#import "MKAnnotationView+JKIM_YYWebImage.h"
#endif

#if __has_include(<JKIM_YYImage/JKIM_YYImage.h>)
#import <JKIM_YYImage/JKIM_YYImage.h>
#elif __has_include(<JKIM_YYWebImage/JKIM_YYImage.h>)
#import <JKIM_YYWebImage/JKIM_YYImage.h>
#import <JKIM_YYWebImage/JKIM_YYFrameImage.h>
#import <JKIM_YYWebImage/JKIM_YYSpriteSheetImage.h>
#import <JKIM_YYWebImage/JKIM_YYImageCoder.h>
#import <JKIM_YYWebImage/JKIM_YYAnimatedImageView.h>
#else
#import "JKIM_YYImage.h"
#import "JKIM_YYFrameImage.h"
#import "JKIM_YYSpriteSheetImage.h"
#import "JKIM_YYImageCoder.h"
#import "JKIM_YYAnimatedImageView.h"
#endif

#if __has_include(<JKIM_YYCache/JKIM_YYCache.h>)
#import <JKIM_YYCache/JKIM_YYCache.h>
#elif __has_include(<JKIM_YYWebImage/JKIM_YYCache.h>)
#import <JKIM_YYWebImage/JKIM_YYCache.h>
#import <JKIM_YYWebImage/JKIM_YYMemoryCache.h>
#import <JKIM_YYWebImage/JKIM_YYDiskCache.h>
#import <JKIM_YYWebImage/JKIM_YYKVStorage.h>
#else
#import "JKIM_YYCache.h"
#import "JKIM_YYMemoryCache.h"
#import "JKIM_YYDiskCache.h"
#import "JKIM_YYKVStorage.h"
#endif

