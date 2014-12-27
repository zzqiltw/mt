//
//  ZQTranslateViewController.m
//  MT
//
//  Created by zzqiltw on 14-12-27.
//  Copyright (c) 2014年 zzqiltw. All rights reserved.
//

#import "ZQTranslateViewController.h"
#import <TSMessage.h>
@interface ZQTranslateViewController ()
@property (nonatomic, assign) TranslateType type;
@end

@implementation ZQTranslateViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.type = [[NSUserDefaults standardUserDefaults] integerForKey:TranslateTypeKey];
    
    NSString *title = [NSString stringWithFormat:@"当前是%@模式", self.type == TranslateTypeEn2Cn ? @"英译汉" : @"汉译英"];
    [TSMessage showNotificationInViewController:self title:title subtitle:nil type:TSMessageNotificationTypeSuccess duration:3.8f canBeDismissedByUser:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"翻译";

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

@end
