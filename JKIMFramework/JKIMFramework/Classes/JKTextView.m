//
//  JKTextView.m
//  JKIMSDKProject
//
//  Created by Jerry on 2019/10/25.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKTextView.h"

@implementation JKTextView

-(instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if(action ==@selector(copy:) ||
       
       action ==@selector(selectAll:)||
       
       action ==@selector(select:)) {
        
        return YES;
        
    }
    
    
    
    return NO;
}
-(void)copy:(id)sender{
    [super copy:sender];
    self.selectedRange = NSMakeRange(0, 0);
    
}
//- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
//    return NO;
//}
@end
