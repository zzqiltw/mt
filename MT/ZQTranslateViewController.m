
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
#import "ZQTranslateTools.h"
#import <TSMessage.h>
#import "MBProgressHUD+ZQ.h"

#define ZQFooterViewHeight 30

@interface ZQTranslateViewController () <ZQKeyboardToolViewDelegate, ZQTranslateHeaderViewDelegate>

@property (nonatomic, assign) TranslateType type;
@property (nonatomic, strong) NSMutableArray *translateModelFrameList;

@property (nonatomic, weak) UIButton *evaluationButton;

@end

@implementation ZQTranslateViewController

- (NSMutableArray *)translateModelFrameList
{
    if (_translateModelFrameList == nil) {
        _translateModelFrameList = [NSMutableArray array];
    }
    return _translateModelFrameList;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"翻译";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    imageView.userInteractionEnabled = YES;
    self.tableView.backgroundView = imageView;
    
    [self.tableView registerClass:[ZQTranslateViewCell class] forCellReuseIdentifier:TranslateCellID];
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    UIButton *evaluationButton = [[UIButton alloc] init];
    evaluationButton.frame = CGRectMake(5, 5, 310, ZQFooterViewHeight);
    [evaluationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [evaluationButton setTitle:@"查看译文BLEU评价结果" forState:UIControlStateNormal];
    evaluationButton.titleLabel.font = [UIFont systemFontOfSize:13];
    evaluationButton.layer.cornerRadius = 4;
    evaluationButton.backgroundColor = ZQColor(40, 175, 179, 0.7);
    evaluationButton.hidden = YES;
    [footerView addSubview:evaluationButton];
    self.evaluationButton = evaluationButton;
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
    ZQTranslateViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TranslateCellID forIndexPath:indexPath];
    cell.translateFrame = self.translateModelFrameList[indexPath.row];
    return cell;
}


- (void)keyboardToolView:(ZQKeyboardToolView *)toolView didClickQuitBtn:(id)sender
{
    [self quitKb];
    self.evaluationButton.hidden = YES;
}

- (void)keyboardToolView:(ZQKeyboardToolView *)toolView didClickClearBtn:(id)sender
{
    [self.translateModelFrameList removeAllObjects];
    [self.tableView reloadData];
    [self quitKb];
    [self clearInputField];
}

- (void)refreshDataWithIcon:(NSString *)icon text:(NSString *)text srcText:(NSString *)srcText
{
    ZQTranslateModel *model = [[ZQTranslateModel alloc] init];
    model.iconName = icon;
    model.srcText = [NSString stringWithFormat:@"原文:%@", srcText];
    model.text = [NSString stringWithFormat:@"译文:%@", text];
    ZQTranslateFrame *modelFrame = [[ZQTranslateFrame alloc] initWithModel:model];
    [self.translateModelFrameList addObject:modelFrame];
    [self.tableView reloadData];
}

- (void)hidHudAndEvaluaBtn:(MBProgressHUD *)hud
{
    [hud hide:YES];
    self.evaluationButton.hidden = NO;
}

- (void)translateHeaderView:(ZQTranslateHeaderView *)headerView didClickTranslateBtn:(id)sender withInput:(NSString *)srcText
{

    self.evaluationButton.hidden = YES;
    [self.translateModelFrameList removeAllObjects];
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"正在加载"];
    
    [ZQTranslateTools googleTranslate:srcText ofType:self.type success:^(NSString *googleResult) {
        [self refreshDataWithIcon:@"google.png" text:googleResult srcText:srcText];
        [self hidHudAndEvaluaBtn:hud];
    } failure:^(NSError *error) {
        
    }];
    
    [ZQTranslateTools baiduTranslate:srcText ofType:self.type success:^(ZQBaiduTranslateResult *result) {

        ZQBaiduTranslateResultItem *item = result.trans_result[0];
        [self refreshDataWithIcon:@"baidu.png" text:item.dst srcText:srcText];
        
        [self hidHudAndEvaluaBtn:hud];
    } failure:^(NSError *error) {
        [hud hide:YES];
        [MBProgressHUD showError:@"加载失败"];
        [TSMessage showNotificationInViewController:self title:@"请检查网络连接！" subtitle:nil type:TSMessageNotificationTypeWarning duration:0.8f canBeDismissedByUser:YES];
    }];
    
    [ZQTranslateTools youdaoTranslate:srcText ofType:self.type success:^(ZQYoudaoTranslateResult *youdaoResult) {
        
        NSMutableArray *youdaoResultTexts = [NSMutableArray array];
        for (NSString *locResult in youdaoResult.translation) {
            [youdaoResultTexts addObject:locResult];
        }
//        for (ZQYoudaoTranslateResultWebItem *webResultKeyValues in youdaoResult.web) {
//            [youdaoResultTexts addObject:webResultKeyValues.value[0]];
//        }
        for (NSString *resultText in youdaoResultTexts) {
            [self refreshDataWithIcon:@"youdao.png" text:resultText srcText:srcText];
        }
        
        [self hidHudAndEvaluaBtn:hud];
    } failure:^(NSError *error) {
        [hud hide:YES];
        [MBProgressHUD showError:@"加载失败"];
        [TSMessage showNotificationInViewController:self title:@"请检查网络连接！" subtitle:nil type:TSMessageNotificationTypeWarning duration:0.8f canBeDismissedByUser:YES];
    }];
    
    
    
//    [ZQTranslateTools icibaTranslate:srcText ofType:self.type];
    return;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        if (self.translateModelFrameList == nil) {
            ZQTranslateModel *model1 = [[ZQTranslateModel alloc] init];
            model1.iconName = @"google.png";
            model1.text = @"google的译文1";
            ZQTranslateFrame *frame1 = [[ZQTranslateFrame alloc] initWithModel:model1];
            
            ZQTranslateModel *model2 = [[ZQTranslateModel alloc] init];
            model2.iconName = @"baidu.png";
            model2.text = @"百度的译文百度的译文百度的译文百度的译文百度的译文百度的译文百度的译文百度的译文百度的译文百度的译文百度的译文百度的译文百度的译文百度的译文百度的译文百度的译文百度的译文";
            ZQTranslateFrame *frame2 = [[ZQTranslateFrame alloc] initWithModel:model2];
            
            ZQTranslateModel *model3 = [[ZQTranslateModel alloc] init];
            model3.iconName = @"biying.png";
            model3.text = @"必应的译文3";
            ZQTranslateFrame *frame3 = [[ZQTranslateFrame alloc] initWithModel:model3];
            
            ZQTranslateModel *model4 = [[ZQTranslateModel alloc] init];
            model4.iconName = @"youdao.png";
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
    self.evaluationButton.hidden = YES;
}
@end
