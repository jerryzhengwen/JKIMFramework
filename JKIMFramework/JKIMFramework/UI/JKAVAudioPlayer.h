//
//  UUAVAudioPlayer.h
//  BloodSugarForDoc
//
//  Created by zzx on 2019/3/12.
//  Copyright © 2019 于飞. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>


@protocol JKAVAudioPlayerDelegate <NSObject>

- (void)JKAVAudioPlayerBeiginLoadVoice;
- (void)JKAVAudioPlayerBeiginPlay;
- (void)JKAVAudioPlayerDidFinishPlay;

@end

@interface JKAVAudioPlayer : NSObject

@property (nonatomic, assign)id <JKAVAudioPlayerDelegate>delegate;
+ (JKAVAudioPlayer *)sharedInstance;

-(void)playSongWithUrl:(NSString *)songUrl;
-(void)playSongWithData:(NSData *)songData;

- (void)stopSound;
@end
