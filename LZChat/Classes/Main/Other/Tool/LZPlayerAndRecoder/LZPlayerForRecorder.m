//
//  LZPlayerForRecorder.m
//  录音机
//
//  Created by Mr.Right on 16/3/28.
//  Copyright © 2016年 lizheng. All rights reserved.
//

#import "LZPlayerForRecorder.h"
#import <AVFoundation/AVFoundation.h>

@interface LZPlayerForRecorder ()
@property(nonatomic,strong) AVAudioPlayer *player;

@end

@implementation LZPlayerForRecorder

#pragma mark 外部方法
- (void)startPlay {
    if (![self.player isPlaying]) {
        [self.player play];
    }
}

- (void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
}

#pragma mark - 初始化
- (AVAudioPlayer *)player {
    if (!_player) {
        NSError *error = nil;
//        LZLog(@"%@",[NSURL URLWithString:_filePath]);        
        NSData *audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_filePath]];
        //将数据保存到本地指定位置
        NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@.wav", docDirPath , @"temp"];
        [audioData writeToFile:filePath atomically:YES];
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];

        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:&error];

        if (error) {
            LZLog(@"播放器创建失败:%@",error);
        }
    }
    return _player;
}
@end
