//
//  ZQVoiceRecognizeViewController.m
//  MT
//
//  Created by zzqiltw on 15/5/29.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import "ZQVoiceRecognizeViewController.h"
#import "ActionButton.h"
#import <iflyMSC/IFlySpeechRecognizer.h>

@interface ZQVoiceRecognizeViewController ()<IFlySpeechRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet ActionButton *recordBtn;
@property (nonatomic, weak) IFlySpeechRecognizer *recognizer;
- (IBAction)touchDownRecord:(id)sender;
- (IBAction)touchUp:(id)sender;

@end

@implementation ZQVoiceRecognizeViewController

static NSString * const msgPre = @"按住按钮进行录音";
static NSString * const msgBegin = @"正在录音";
static NSString * const msgEnd = @"正在将录音转换成文字";

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.messageLabel.text = msgPre;
    
    self.recognizer = [IFlySpeechRecognizer sharedInstance];
    self.recognizer.delegate = self;
    
    [self.recognizer setParameter:@"iat" forKey:@"domain"];
    [self.recognizer setParameter:@"8000" forKey:@"sample_rate"];
    
}


- (IBAction)touchDownRecord:(id)sender {
    self.messageLabel.text = msgBegin;
    
    [self.recognizer startListening];
}

- (IBAction)touchUp:(id)sender {
    self.messageLabel.text = msgEnd;
    
    [self.recognizer stopListening];
}

- (void)onResults:(NSArray *)results isLast:(BOOL)isLast
{
    NSLog(@"语音识别success:%@", results);
}

- (void)onError:(IFlySpeechError *)errorCode
{
    NSLog(@"语音识别error:%@", errorCode);
}

@end
