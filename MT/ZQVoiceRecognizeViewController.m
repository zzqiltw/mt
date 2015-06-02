//
//  ZQVoiceRecognizeViewController.m
//  MT
//
//  Created by zzqiltw on 15/5/29.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import "ZQVoiceRecognizeViewController.h"
#import "ActionButton.h"
#import "ISRDataHelper.h"
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
static NSString * const msgSuccess = @"识别成功";
static NSString * const msgError = @"语音服务识别失败";

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.messageLabel.text = msgPre;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopAll];
    [super viewWillDisappear:animated];
}

- (void)stopAll
{
    [self.recognizer cancel];
    self.recognizer.delegate = nil;
}

- (void)preparedAll
{
    self.recognizer = [IFlySpeechRecognizer sharedInstance];
    self.recognizer.delegate = self;
    
    if (self.type == TranslateTypeEn2Cn) {
        [self.recognizer setParameter:@"en_us" forKey:@"language"];
    } else {
        [self.recognizer setParameter:@"iat" forKey:@"domain"];
    }
}

- (IBAction)touchDownRecord:(id)sender {
    self.messageLabel.text = msgBegin;
    
    [self preparedAll];
    [self.recognizer startListening];
}

- (IBAction)touchUp:(id)sender {
    if (self.messageLabel.text isEqualToString:msgError) {
        return;
    }
    self.messageLabel.text = msgEnd;
    
    [self.recognizer stopListening];
}

- (void)onResults:(NSArray *)results isLast:(BOOL)isLast
{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    self.messageLabel.text = msgSuccess;
    NSString * resultFromJson =  [[ISRDataHelper shareInstance] getResultFromJson:resultString];
    
    NSLog(@"语音识别success:%@", resultFromJson);

    [self stopAll];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:GetRecognizeSentenceNotification object:nil userInfo:@{GetRecognizeSentenceNotificationKey : resultFromJson}];
}

- (void)onError:(IFlySpeechError *)errorCode
{
    NSLog(@"语音识别error:%d", errorCode.errorCode);
    self.messageLabel.text = msgError;
    [self stopAll];
}

@end
