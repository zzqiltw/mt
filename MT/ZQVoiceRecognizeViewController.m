//
//  ZQVoiceRecognizeViewController.m
//  MT
//
//  Created by zzqiltw on 15/5/29.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import "ZQVoiceRecognizeViewController.h"
#import "ActionButton.h"
#import "ZQRecordTool.h"
@interface ZQVoiceRecognizeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet ActionButton *recordBtn;
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
}


- (IBAction)touchDownRecord:(id)sender {
    self.messageLabel.text = msgBegin;
    
    ZQRecordTool *recordTool = [ZQRecordTool sharedRecordTool];
    [recordTool startRecord];
}

- (IBAction)touchUp:(id)sender {

    self.messageLabel.text = msgEnd;
    ZQRecordTool *recordTool = [ZQRecordTool sharedRecordTool];
    [recordTool stopRecording];
    
    NSString *recordData = [recordTool getRecordData];
    NSLog(@"%@", recordData.length);
}

@end
