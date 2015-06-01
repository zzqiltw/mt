//
//  ZQRecordTool.m
//  MT
//
//  Created by zzqiltw on 15/5/30.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import "ZQRecordTool.h"
#import <AVFoundation/AVFoundation.h>
@interface ZQRecordTool()
@property(nonatomic, strong) AVAudioRecorder *recorder;
@end

@implementation ZQRecordTool

+ (instancetype)sharedRecordTool
{
    static ZQRecordTool *sharedRecorder;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedRecorder = [[ZQRecordTool alloc] init];
    });
    return sharedRecorder;
}

- (id)init
{
    if (self = [super init]) {
        // 1.创建录音器
//        NSDictionary *setting = [NSDictionary dictionaryWithObjectsAndKeys:
//                                       [NSNumber numberWithInt:AVAudioQualityLow],AVEncoderAudioQualityKey,
//                                       [NSNumber numberWithInt:16],AVEncoderBitRateKey,
//                                       [NSNumber numberWithInt:2],AVNumberOfChannelsKey,
//                                       [NSNumber numberWithFloat:44100.0],AVSampleRateKey,
//                                       nil];

        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
//        // 音频格式
//        setting[AVFormatIDKey] = @(kAudioFormatAppleIMA4);
//        // 音频采样率
//        setting[AVSampleRateKey] = @(8000);
//        // 音频通道数
//        setting[AVNumberOfChannelsKey] = @(1);
//        // 线性音频的位深度
//        setting[AVLinearPCMBitDepthKey] = @(16);

        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"record.%@", @"caf"]];
        // 注意这里是fileURL！！！
        NSURL *outputFileURL = [NSURL fileURLWithPath:path];
        NSLog(@"%@", outputFileURL.absoluteString);

        NSError *error = nil;
        AVAudioRecorder *recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL
                                                                settings:setting
                                                                   error:&error];
        self.recorder = recorder;
        [self.recorder prepareToRecord];
    }
    return self;
}

- (void)startRecord
{
    [self.recorder record];
}

- (void)stopRecording
{
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }
}

- (NSString *)getRecordData
{
    NSData *data = [NSData dataWithContentsOfURL:self.recorder.url];
    if (data != nil) {
        return [data base64EncodedStringWithOptions:0];
    }
    return nil;
}


@end
