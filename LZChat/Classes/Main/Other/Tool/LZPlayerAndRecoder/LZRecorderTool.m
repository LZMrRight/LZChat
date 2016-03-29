//
//  LZRecorderTool.m
//  录音机
//
//  Created by Mr.Right on 16/3/28.
//  Copyright © 2016年 lizheng. All rights reserved.
//

#import "LZRecorderTool.h"
#import <AVFoundation/AVAudioRecorder.h>
#import <AVFoundation/AVAudioSession.h>
//#import <CoreAudioKit/CoreAudioKit.h>

@interface LZRecorderTool ()
@property(nonatomic,strong) AVAudioRecorder *recorder;
@property(nonatomic,strong) NSTimer *timer;
@end

@implementation LZRecorderTool

- (void)startRecorde {
    if (![self.recorder isRecording]) {
        [self.recorder record];
        self.timer.fireDate = [NSDate distantPast];// 开启定时器
    }
}

- (void)pauseRecorde {
    if ([self.recorder isRecording]) {
        self.timer.fireDate = [NSDate distantFuture]; // 关闭定时器
        [self.recorder pause];
    }
}

- (void)stopRecorde {
    // 告知外部录音文件时常
    self.currentTime = self.recorder.currentTime;
    
    [self.recorder stop];
    self.recorder = nil;

    self.timer = nil;
    self.audioPower = 0.0;

}
/**
 *  监测声波变化
 */
- (void)audioPowerChanged {
    [self.recorder updateMeters];
    
    float power = [self.recorder averagePowerForChannel:0]; //取得第一个通道的音频，注意音频强度范围时-160到0
    
    self.audioPower = (CGFloat)(1.0/160.0) * (power+160.0);
}

#pragma mark - 初始化
- (instancetype)init {
    if (self = [super init]) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];

        [session setActive:YES error:nil];
    }
    return self;
}
- (AVAudioRecorder *)recorder {
    if (_recorder == nil) {
        self.fileName = [self file];
        NSString *tempDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [tempDir stringByAppendingPathComponent:self.fileName];
        _recorder = [[AVAudioRecorder alloc]initWithURL:[NSURL URLWithString: path] settings:[self getAudioSetting] error:nil];
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
    }
    return _recorder;
}
/**
 *  缓存地址
 */
- (NSString *)file {
    
    NSDateFormatter *forma = [[NSDateFormatter alloc]init];
    forma.dateFormat = @"yyyymmddhhmmss";
    NSString *time = [forma stringFromDate:[NSDate date]];
    
//    NSString *tempDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *file = [NSString stringWithFormat:@"%@.mp3",time];
    
    return file;
}
/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
-(NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    //设置录音格式
//    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    return dicM;
}
/**
 *  监测声波变化
 */
- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerChanged) userInfo:nil repeats:YES];
    }
    return _timer;
}

@end
