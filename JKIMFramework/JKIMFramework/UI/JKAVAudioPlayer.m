//
//  UUAVAudioPlayer.m
//  BloodSugarForDoc
//
//  Created by zzx on 2019/3/12.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKAVAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>


@interface JKAVAudioPlayer ()<AVAudioPlayerDelegate>
{
    AVAudioPlayer *player;
}
@end

@implementation JKAVAudioPlayer

+ (JKAVAudioPlayer *)sharedInstance
{
    static JKAVAudioPlayer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });    
    return sharedInstance;
}

-(void)playSongWithUrl:(NSString *)songUrl
{
    dispatch_async(dispatch_queue_create("dfsfe", NULL), ^{
        
        [self.delegate JKAVAudioPlayerBeiginLoadVoice];
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:songUrl]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (player) {
                [self.delegate JKAVAudioPlayerDidFinishPlay];
                [player stop];
                player.delegate = nil;
                player = nil;
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"VoicePlayHasInterrupt" object:nil];
            NSError *playerError;
            player = [[AVAudioPlayer alloc]initWithData:data error:&playerError];
            player.volume = 1.0f;
            if (player == nil){
                NSLog(@"ERror creating player: %@", [playerError description]);
            }
            [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
            player.delegate = self;
            [player play];
            [self.delegate JKAVAudioPlayerBeiginPlay];
        });
    });
}

-(void)playSongWithData:(NSData *)songData
{
    [self.delegate JKAVAudioPlayerDidFinishPlay];

    if (player) {
        [player stop];
        player.delegate = nil;
        player = nil;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"VoicePlayHasInterrupt" object:nil];
    NSError *playerError;
    player = [[AVAudioPlayer alloc]initWithData:songData error:&playerError];
    player.volume = 1.0f;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
    player.delegate = self;
    [player play];
    [self.delegate JKAVAudioPlayerBeiginPlay];

}



- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.delegate JKAVAudioPlayerDidFinishPlay];
}

- (void)stopSound
{
    if (player && player.isPlaying) {
        [player stop];
    }
}

@end
