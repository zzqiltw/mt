
//
//  ZQTranslateViewController.m
//  MT
//
//  Created by zzqiltw on 14-12-27.
//  Copyright (c) 2014年 zzqiltw. All rights reserved.
//

#import "ZQTranslateViewController.h"
#import "ZQTranslateHeaderView.h"
#import "ZQTranslateFooterView.h"
#import "ZQKeyboardToolView.h"
#import "ZQTranslateModel.h"
#import "ZQTranslateViewCell.h"
#import "ZQTranslateTools.h"
#import <TSMessage.h>
#import "MBProgressHUD+ZQ.h"
#import "ZQBLEUModel.h"

#define ZQTestSentenceTranslateResultFilePath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"testSrcAnd4TraOutputFile400_499"]
const NSInteger ZQCount = 100;

typedef enum {
    ZQActionSheetIndexTypeCancel,
    ZQActionSheetIndexTypeBLEU,
    ZQActionSheetIndexTypeSystemCombine
} ZQActionSheetIndexType;

@interface ZQTranslateViewController () <ZQKeyboardToolViewDelegate, ZQTranslateHeaderViewDelegate, ZQTranslateFooterViewDelegate,UIActionSheetDelegate>

@property (nonatomic, assign) TranslateType type;
@property (nonatomic, strong) NSMutableArray *translateModelFrameList;
@property (nonatomic, weak) ZQTranslateFooterView *footerView;
@property (nonatomic, strong) NSMutableArray *bleuSrc;
@property (nonatomic, strong) NSMutableArray *bleuModels;
@property (nonatomic, assign) NSInteger stepCount;

@end

@implementation ZQTranslateViewController

- (NSMutableArray *)bleuModels
{
    if (_bleuModels == nil) {
        _bleuModels = [NSMutableArray arrayWithCapacity:998];
    }
    return _bleuModels;
}

- (NSMutableArray *)bleuSrc
{
    if (_bleuSrc == nil) {
        _bleuSrc = [NSMutableArray arrayWithCapacity:998];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"devSrc.plist" ofType:nil];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        for (NSInteger i = 0; i < array.count; ++i) {
            [_bleuSrc addObject:array[i]];
        }
    }
    return _bleuSrc;
}

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
    
    self.stepCount = 0;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.tableView.alwaysBounceVertical = NO;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    imageView.userInteractionEnabled = YES;
    self.tableView.backgroundView = imageView;
    
    [self.tableView registerClass:[ZQTranslateViewCell class] forCellReuseIdentifier:TranslateCellID];
    
    ZQTranslateFooterView *footerView = [[ZQTranslateFooterView alloc] init];
    // 这个frame要设置，否则不能点
    footerView.frame = CGRectMake(0, 0, 0, ZQFooterViewHeight);
    footerView.hidden = YES;
    footerView.delegate = self;
    self.footerView = footerView;
    self.tableView.tableFooterView = footerView;
}

- (void)footerView:(ZQTranslateFooterView *)footerView didClickButton:(UIButton *)button
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"分析译文" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"查看BLEU评价结果", @"查看系统融合结果", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case ZQActionSheetIndexTypeBLEU:
            NSLog(@"BLEU");
            break;
        case ZQActionSheetIndexTypeSystemCombine:
            NSLog(@"System Combine");
            break;
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.type = [[NSUserDefaults standardUserDefaults] integerForKey:TranslateTypeKey];
    
    NSString *title = [NSString stringWithFormat:@"%@", self.type == TranslateTypeEn2Cn ? @"英译汉模式" : @"汉译英模式"];
    self.title = title;
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
    self.footerView.hidden = YES;
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
    self.footerView.hidden = NO;
}

//- (void)saveBleuModel:(ZQBLEUModel *)model ofIndex:(NSInteger)i
//{
//    if (model.baiduGet && model.youdaoGet && model.googleGet && model.bingGet) {
//        self.stepCount ++;
//        NSLog(@"i=%ld step = %ld", i, (long)self.stepCount);
//        if (self.stepCount == ZQCount) {
//            NSArray *array = [ZQBLEUModel keyValuesArrayWithObjectArray:self.bleuModels];
//            NSData *data = [NSJSONSerialization dataWithJSONObject:array options:0 error:nil];
//            if (data.length > 0) {
//                [data writeToFile:ZQTestSentenceTranslateResultFilePath atomically:YES];
//            }
//        }
//
//    }
//}


- (void)translateHeaderView:(ZQTranslateHeaderView *)headerView didClickTranslateBtn:(id)sender withInput:(NSString *)srcText
{
    self.footerView.hidden = YES;
    [self.translateModelFrameList removeAllObjects];
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"正在加载"];
    
    [ZQTranslateTools googleTranslate:srcText ofType:self.type success:^(NSString *googleResult) {
        [self refreshDataWithIcon:@"google.png" text:googleResult srcText:srcText];
        [self hidHudAndEvaluaBtn:hud];
    } failure:^(NSError *error) {
        
    }];
    
    [ZQTranslateTools bingTranslate:srcText ofType:self.type success:^(NSString *bingResult) {
        [self refreshDataWithIcon:@"biying.png" text:bingResult srcText:srcText];
        [self hidHudAndEvaluaBtn:hud];
    } failure:^(NSError *error) {
        
    }];
    
    [ZQTranslateTools baiduTranslate:srcText ofType:self.type success:^(ZQBaiduTranslateResult *result) {
        
        ZQBaiduTranslateResultItem *item = result.trans_result[0];
        [self refreshDataWithIcon:@"baidu.png" text:item.dst srcText:srcText];
        
        [self hidHudAndEvaluaBtn:hud];
    } failure:^(NSError *error) {
        [hud hide:YES];
        [MBProgressHUD showError:@"百度翻译结果加载失败"];
        [TSMessage showNotificationInViewController:self title:@"请检查网络连接！" subtitle:nil type:TSMessageNotificationTypeWarning duration:0.8f canBeDismissedByUser:YES];
    }];
    
    [ZQTranslateTools youdaoTranslate:srcText ofType:self.type success:^(ZQYoudaoTranslateResult *youdaoResult) {
        
        NSMutableArray *youdaoResultTexts = [NSMutableArray array];
        for (NSString *locResult in youdaoResult.translation) {
            [youdaoResultTexts addObject:locResult];
        }
        for (NSString *resultText in youdaoResultTexts) {
            [self refreshDataWithIcon:@"youdao.png" text:resultText srcText:srcText];
        }
        
        [self hidHudAndEvaluaBtn:hud];
    } failure:^(NSError *error) {
        //        [hud hide:YES];
        //        [MBProgressHUD showError:@"加载失败"];
        //        [TSMessage showNotificationInViewController:self title:@"请检查网络连接！" subtitle:nil type:TSMessageNotificationTypeWarning duration:0.8f canBeDismissedByUser:YES];
    }];

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        for (NSInteger i = 0; i < ZQCount; ++i) {
//            NSInteger j = i + ZQCount * 2;
//            ZQBLEUModel *bleuModel = [[ZQBLEUModel alloc] init];
//            bleuModel.ID = j;
//            bleuModel.src = self.bleuSrc[j];
//            bleuModel.baiduGet = NO;
//            bleuModel.googleGet = NO;
//            bleuModel.bingGet = NO;
//            bleuModel.youdaoGet = NO;
//            
//            [self.bleuModels addObject:bleuModel];
//            
//            [ZQTranslateTools bingTranslate:bleuModel.src ofType:self.type success:^(NSString *bingResult) {
//                NSInteger currentIndex = [self.bleuModels indexOfObject:bleuModel];
//
//                bleuModel.bingTra = bingResult;
//                bleuModel.bingGet = YES;
//                [self saveBleuModel:bleuModel ofIndex:currentIndex];
//            } failure:^(NSError *error) {
//                
//            }];
//            
//            [ZQTranslateTools baiduTranslate:bleuModel.src ofType:self.type success:^(ZQBaiduTranslateResult *result) {
//                NSInteger currentIndex = [self.bleuModels indexOfObject:bleuModel];
//
//                ZQBaiduTranslateResultItem *item = result.trans_result[0];
//                bleuModel.baiduTra = item.dst;
//                
//                bleuModel.baiduGet = YES;
//                [self saveBleuModel:bleuModel ofIndex:currentIndex];
//            } failure:^(NSError *error) {
//            }];
//            
//            [ZQTranslateTools googleTranslate:bleuModel.src ofType:self.type success:^(NSString *googleResult) {
//
//                NSInteger currentIndex = [self.bleuModels indexOfObject:bleuModel];
//                bleuModel.googleTra = googleResult;
//                
//                bleuModel.googleGet = YES;
//                [self saveBleuModel:bleuModel ofIndex:currentIndex];
//            } failure:^(NSError *error) {
//                
//            }];
//            
//            [ZQTranslateTools youdaoTranslate:bleuModel.src ofType:self.type success:^(ZQYoudaoTranslateResult *youdaoResult) {
//                NSInteger currentIndex = [self.bleuModels indexOfObject:bleuModel];
//                bleuModel.youdaoTra = youdaoResult.translation.firstObject;
//                
//                bleuModel.youdaoGet = YES;
//                [self saveBleuModel:bleuModel ofIndex:currentIndex];
//            } failure:^(NSError *error) {
//            }];
//        }
//        
//    });
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
    self.footerView.hidden = YES;
}
@end
