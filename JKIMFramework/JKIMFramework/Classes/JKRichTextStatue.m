//
//  JKRichTextStatue.m
//  TestSDK
//
//  Created by Jerry on 2019/3/18.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKRichTextStatue.h"
#import "RegexKitLite.h"
#import "JKTextPat.h"
#import <UIKit/UIKit.h>
#import "JKBundleTool.h"

@implementation JKRichTextStatue
-(void)setText:(NSString *)text {
    _text = [text copy];
    self.attributedText = [self attributedTextWithText:text];
}
- (NSAttributedString *)attributedTextWithText:(NSString *)text {
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    if ([text isEqualToString:@""]) {return attributedText;}
    // 表情的规则
    NSString *emotionPattern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
    // url链接的规则
    NSString *urlPattern = JK_URlREGULAR;
    // 号码的规则
    NSString *phoneNumber = JK_PHONENUMBERREGLAR;
    
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@", emotionPattern, urlPattern,phoneNumber];
//    NSArray *cmps = [text componentsMatchedByRegex:pattern];
    NSMutableArray *parts = [NSMutableArray array];
    
//    NSString *filePath =[[NSBundle bundleForClass:[self class]]pathForResource:@"JKFace" ofType:@"plist"];
    NSString *filePath = [JKBundleTool initBundlePathWithResouceName:@"JKFace" type:@"plist"];
    NSArray  *face = [NSArray arrayWithContentsOfFile:filePath];
    
    //遍历所有的特殊字符穿
    [text enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        JKTextPat *part =[[JKTextPat alloc] init];
        part.isSpecial = YES;
        part.text = *capturedStrings;
        part.isEmotion = [part.text hasPrefix:@"["] && [part.text hasSuffix:@"]"];
        if (part.isEmotion) {
            BOOL isContain = NO;
            for (int i =0; i <face.count; i ++) {
                if ([face[i][@"face_name"] isEqualToString:part.text]) {
                    isContain = YES;
                    break;
                }
            }
            if (!isContain) {
                part.isSpecial = NO;
                part.isEmotion = NO;
            }
        }
        part.range = *capturedRanges;
        [parts addObject:part];
    }];
    //遍历所有的其他的字符串
    [text enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        JKTextPat *part = [[JKTextPat alloc] init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        [parts addObject:part];
    }];// all
    [parts sortUsingComparator:^NSComparisonResult(JKTextPat * part1, JKTextPat * part2) {
        // NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending
        // 返回NSOrderedSame:两个一样大
        // NSOrderedAscending(升序):part2>part1
        // NSOrderedDescending(降序):part1>part2
        if (part1.range.location > part2.range.location) {
            // part1>part2
            // part1放后面, part2放前面
            return NSOrderedDescending;
        }
        // part1<part2
        // part1放前面, part2放后面
        return NSOrderedAscending;
    }];
    UIFont *font;
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 9.0) {
        font =  [UIFont systemFontOfSize:15];
    }else {//在这里替换下
        font  = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    }
    NSMutableArray *specials = [NSMutableArray array];
//    NSString *bundlePatch =  [[NSBundle bundleForClass:[self class]]pathForResource:@"JKIMImage" ofType:@"bundle"];
    NSString *bundlePatch = [JKBundleTool initBundlePathWithImage];
    for (JKTextPat *part in parts) {
        // 等会需要拼接的子串
        NSAttributedString *substr = nil;
        if (part.isSpecial) {
            if (![part.text containsString:@"http"]) {
                part.isSpecial = NO;
            }
        }
        if (part.isEmotion) { //是表情
            for (int i = 0; i <face.count; i++) {
                if ([face[i][@"face_name"] isEqualToString:part.text]) {
                    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                     NSString *filePatch =  [bundlePatch stringByAppendingPathComponent:face[i][@"face_image_name"]];
                    textAttachment.image = [UIImage imageWithContentsOfFile:filePatch];
                    textAttachment.bounds = CGRectMake(0, -6, 25, 25);
                    substr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                    break;
                }
            }
        }else if (part.isSpecial){
//            NSURL *url =[NSURL URLWithString:part.text];
//            if (url.scheme) { //网页链接
//                substr = [[NSAttributedString alloc] initWithString:part.text attributes:
//                          @{NSForegroundColorAttributeName : [UIColor redColor]}];
//                NSString *string =@"网页链接";
//                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
//                //给附件添加图片
//                textAttachment.image = [UIImage imageNamed:@"链接"];
//                //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
//                textAttachment.bounds = CGRectMake(0, -6, 25, 25);
//                NSMutableAttributedString *tempAttribute = [[NSMutableAttributedString alloc]initWithAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];
//                NSMutableAttributedString *tempAttribute2 = [[NSMutableAttributedString alloc]initWithAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];
//                NSAttributedString *text =[[NSAttributedString alloc]initWithString:string attributes:@{NSForegroundColorAttributeName:[UIColor blueColor]}];
//                [tempAttribute appendAttributedString:text];
//                substr = [[NSAttributedString alloc]initWithAttributedString:tempAttribute];
//                // 创建特殊对象
//            }else {
                substr = [[NSAttributedString alloc] initWithString:part.text attributes:@{
                                                                                           NSLinkAttributeName:[NSString stringWithFormat:@"%@",part.text],NSForegroundColorAttributeName : [UIColor redColor]
                                                                                           }];
//            }
        }else {
             substr = [[NSAttributedString alloc] initWithString:part.text];
        }
        if (substr) {
            [attributedText appendAttributedString:substr];
        }
    }
    [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedText.length)];
//    [attributedText addAttribute:@"specials" value:specials range:NSMakeRange(0, 1)];
//    for (JKTextPat * part in parts) {
//        if (part.isSpecial && !part.isEmotion) { //需要添加链接
//            [attributedText addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%@://",part.text] range:part.range];
//        }
//    }
    return attributedText;
}
@end
