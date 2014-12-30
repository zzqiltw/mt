
//
//  ZQTranslateViewController.m
//  MT
//
//  Created by zzqiltw on 14-12-27.
//  Copyright (c) 2014年 zzqiltw. All rights reserved.
//

#import "ZQTranslateViewController.h"
#import "ZQTranslateHeaderView.h"
#import "ZQKeyboardToolView.h"
#import "ZQTranslateModel.h"
#import "ZQTranslateViewCell.h"
#import <TSMessage.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface ZQTranslateViewController () <ZQKeyboardToolViewDelegate, ZQTranslateHeaderViewDelegate>

@property (nonatomic, assign) TranslateType type;
@property (nonatomic, strong) NSMutableArray *translateModelFrameList;

@end

@implementation ZQTranslateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"翻译";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    imageView.userInteractionEnabled = YES;
    self.tableView.backgroundView = imageView;
    
    [self.tableView registerClass:[ZQTranslateViewCell class] forCellReuseIdentifier:TranslateCellID];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.type = [[NSUserDefaults standardUserDefaults] integerForKey:TranslateTypeKey];
    
    NSString *title = [NSString stringWithFormat:@"%@", self.type == TranslateTypeEn2Cn ? @"英译汉模式" : @"汉译英模式"];
    [TSMessage showNotificationInViewController:self title:title subtitle:nil type:TSMessageNotificationTypeSuccess duration:0.8f canBeDismissedByUser:YES];
    
    ZQTranslateHeaderView *headerView = [[ZQTranslateHeaderView alloc] init];
    headerView.modeType = title;
    headerView.delegate = self;
    self.tableView.tableHeaderView = headerView;
    
    ZQKeyboardToolView *toolView = [[ZQKeyboardToolView alloc] init];
    toolView.delegate = self;
    
    [headerView setInputFieldAccessoryView:toolView];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.translateModelFrameList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZQTranslateFrame *currentCellFrame = self.translateModelFrameList[indexPath.row];
    return currentCellFrame.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#warning 这里要不要indexpath
    ZQTranslateViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TranslateCellID forIndexPath:indexPath];
    cell.translateFrame = self.translateModelFrameList[indexPath.row];
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self quitKb];
}

- (void)keyboardToolView:(ZQKeyboardToolView *)toolView didClickQuitBtn:(id)sender
{
    [self quitKb];
}

- (void)keyboardToolView:(ZQKeyboardToolView *)toolView didClickClearBtn:(id)sender
{
    [self.translateModelFrameList removeAllObjects];
    [self.tableView reloadData];
    [self quitKb];
    [self clearInputField];
}

- (void)translateHeaderView:(ZQTranslateHeaderView *)headerView didClickTranslateBtn:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        if (self.translateModelFrameList == nil) {
            ZQTranslateModel *model1 = [[ZQTranslateModel alloc] init];
            model1.iconName = @"google.png";
            model1.text = @"google的译文1";
            ZQTranslateFrame *frame1 = [[ZQTranslateFrame alloc] initWithModel:model1];
            
            ZQTranslateModel *model2 = [[ZQTranslateModel alloc] init];
            model2.iconName = @"google.png";
            model2.text = @"百度的译文百度的译文百度的译文百度的译文百度的译文百度的译文百度的译文百度的译文百度的译文百度的译文百度的译文百度的译文百度的译文百度的译文百度的译文百度的译文百度的译文";
            ZQTranslateFrame *frame2 = [[ZQTranslateFrame alloc] initWithModel:model2];
            
            ZQTranslateModel *model3 = [[ZQTranslateModel alloc] init];
            model3.iconName = @"google.png";
            model3.text = @"必应的译文3";
            ZQTranslateFrame *frame3 = [[ZQTranslateFrame alloc] initWithModel:model3];
            
            ZQTranslateModel *model4 = [[ZQTranslateModel alloc] init];
            model4.iconName = @"google.png";
            model4.text = @"有道的译文4";
            ZQTranslateFrame *frame4 = [[ZQTranslateFrame alloc] initWithModel:model4];
            
            ZQTranslateModel *model5 = [[ZQTranslateModel alloc] init];
            model5.iconName = @"google.png";
            model5.text = @"最优的译文5";
            ZQTranslateFrame *frame5 = [[ZQTranslateFrame alloc] initWithModel:model5];
            
            _translateModelFrameList = [NSMutableArray arrayWithArray:@[frame1, frame2, frame3, frame4, frame5]];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView reloadData];
    });
}

- (void)quitKb
{
    ZQTranslateHeaderView *headerView = (ZQTranslateHeaderView *)self.tableView.tableHeaderView;
    [headerView quitKb];
}

- (void)clearInputField
{
    ZQTranslateHeaderView *headerView = (ZQTranslateHeaderView *)self.tableView.tableHeaderView;
    [headerView clearInputField];
}
@end
