//
//  ZQSpeechSynthesizer.h
//  MT
//
//  Created by zzqiltw on 15/6/1.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//


/**
 *  语音播放
 */
#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface ZQSpeechSynthesizer : NSObject
SingletonH(SpeechSynthesizer)

- (void)speech:(NSString *)sentence;
@end
