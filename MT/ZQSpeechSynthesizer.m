//
//  ZQSpeechSynthesizer.m
//  MT
//
//  Created by zzqiltw on 15/6/1.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import "ZQSpeechSynthesizer.h"
#import <iflyMSC/IFlySpeechSynthesizer.h>
#import <iflyMSC/IFlySpeechConstant.h>
@interface ZQSpeechSynthesizer()<IFlySpeechSynthesizerDelegate>
@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;
@end
@implementation ZQSpeechSynthesizer
SingletonM(SpeechSynthesizer)

- (IFlySpeechSynthesizer *)iFlySpeechSynthesizer
{
    if (_iFlySpeechSynthesizer == nil) {
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance]; _iFlySpeechSynthesizer.delegate = self;
        //设置语音合成的参数
        //语速,取值范围 0~100
        [_iFlySpeechSynthesizer setParameter:@"80" forKey:[IFlySpeechConstant SPEED]];
        //音量;取值范围 0~100
        [_iFlySpeechSynthesizer setParameter:@"50" forKey: [IFlySpeechConstant VOLUME]];
        //发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表
        [_iFlySpeechSynthesizer setParameter:@"vils" forKey: [IFlySpeechConstant VOICE_NAME]];
        //音频采样率,目前支持的采样率有 16000 和 8000
        [_iFlySpeechSynthesizer setParameter:@"8000" forKey: [IFlySpeechConstant SAMPLE_RATE]]; //asr_audio_path保存录音文件路径,如不再需要,设置value为nil表示取消,默认目录是 documents
//        [_iFlySpeechSynthesizer setParameter:@" tts.pcm" forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
        [_iFlySpeechSynthesizer setParameter:nil forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
    }
    return _iFlySpeechSynthesizer;
}

- (void)speech:(NSString *)sentence
{
    [self.iFlySpeechSynthesizer startSpeaking:sentence];
}

- (void)onCompleted:(IFlySpeechError *)error
{
    NSLog(@"%@", error);
}

@end
