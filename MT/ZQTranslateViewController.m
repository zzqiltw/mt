
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
#import "ZQBLEUTool.h"
#import "ZQPDFViewController.h"
#import "ZQWordCutTool.h"
#import "ZQLDPathTool.h"
#import "ZQVoiceRecognizeViewController.h"

#define ZQTestSentenceTranslateResultFilePath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"testSrcAnd4TraOutputFile400_499"]
static const NSInteger ZQNGram = 2;

typedef enum {
    ZQActionSheetIndexTypeCancel,
    ZQActionSheetIndexTypeBLEU,
    ZQActionSheetIndexTypeSystemCombine
} ZQActionSheetIndexType;

@interface ZQTranslateViewController () <ZQKeyboardToolViewDelegate, ZQTranslateHeaderViewDelegate, ZQTranslateFooterViewDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableArray *translateModelFrameList;
@property (nonatomic, weak) ZQTranslateFooterView *footerView;
@property (nonatomic, strong) NSMutableArray *bleuSrc;
@property (nonatomic, strong) NSMutableArray *bleuModels;
@property (nonatomic, assign) NSInteger stepCount;

@property (nonatomic, assign) BOOL baiduGet;
@property (nonatomic, assign) BOOL bingGet;
@property (nonatomic, assign) BOOL youdaoGet;
@property (nonatomic, assign) BOOL googleGet;

@property (nonatomic, copy) NSString *baiduResult;
@property (nonatomic, copy) NSString *bingResult;
@property (nonatomic, copy) NSString *googleResult;
@property (nonatomic, copy) NSString *youdaoResult;


@end

@implementation ZQTranslateViewController

#pragma mark - Lazy Initialize
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

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.stepCount = 0;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"参考" style:UIBarButtonItemStyleDone target:self action:@selector(refClick)];
    
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
    
    ZQTranslateHeaderView *headerView = [[ZQTranslateHeaderView alloc] init];
    headerView.modeType = self.type;
    headerView.delegate = self;
    self.tableView.tableHeaderView = headerView;
    
    ZQKeyboardToolView *toolView = [[ZQKeyboardToolView alloc] init];
    toolView.delegate = self;
    
    [headerView setInputFieldAccessoryView:toolView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *title = [NSString stringWithFormat:@"%@", self.type == TranslateTypeEn2Cn ? @"英译汉模式" : @"汉译英模式"];
    self.title = title;
    [TSMessage showNotificationInViewController:self title:title subtitle:nil type:TSMessageNotificationTypeSuccess duration:0.8f canBeDismissedByUser:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRecognizedSentence:) name:GetRecognizeSentenceNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions
- (void)refClick
{
    ZQPDFViewController *pdfVC = [[ZQPDFViewController alloc] init];
    pdfVC.filename = @"bleu.pdf";
    [self.navigationController pushViewController:pdfVC animated:YES];
}

- (BOOL)dontGetAnything
{
    return !self.googleGet && !self.baiduGet && !self.bingGet && !self.youdaoGet;
}

- (void)failed:(MBProgressHUD *)hud
{
    if ([self dontGetAnything]) {
        [hud hide:YES];
        [MBProgressHUD showError:@"加载失败"];
        [TSMessage showNotificationInViewController:self title:@"请检查网络连接！" subtitle:nil type:TSMessageNotificationTypeWarning duration:0.8f canBeDismissedByUser:YES];
    }
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

#pragma mark - ZQTranslateFooterViewDelegate
- (void)footerView:(ZQTranslateFooterView *)footerView didClickButton:(UIButton *)button
{
    if (self.googleGet && self.baiduGet && self.bingGet && self.youdaoGet) {
        MBProgressHUD *hud = [MBProgressHUD showMessage:@"正在分析..."];
        ZQBLEUTool *bleuTool = [[ZQBLEUTool alloc] init];
        
        NSArray *baiduRefArray = @[self.youdaoResult, self.bingResult, self.googleResult];
        double baiduScore = [bleuTool getBLUEScoreofFirst:self.baiduResult andStrings:baiduRefArray Ngram:ZQNGram ofType:self.type];

        
        NSArray *bingRefArray = @[self.youdaoResult, self.baiduResult, self.googleResult];
        double bingScore = [bleuTool getBLUEScoreofFirst:self.bingResult andStrings:bingRefArray Ngram:ZQNGram ofType:self.type];

        
        NSArray *googleRefArray = @[self.youdaoResult, self.bingResult, self.baiduResult];
        double googleScore = [bleuTool getBLUEScoreofFirst:self.googleResult andStrings:googleRefArray Ngram:ZQNGram ofType:self.type];

        
        NSArray *youdaoRefArray = @[self.baiduResult, self.bingResult, self.googleResult];
        double youdaoScore = [bleuTool getBLUEScoreofFirst:self.youdaoResult andStrings:youdaoRefArray Ngram:ZQNGram ofType:self.type];

        NSLog(@"%@ %@", youdaoRefArray, _youdaoResult);
        for (ZQTranslateFrame *tf in self.translateModelFrameList) {
            ZQTranslateModel *model = tf.model;
            switch (model.type) {
                case TranslateResultSupporterBaidu:
                    model.bleuScore = baiduScore;
                    break;
                case TranslateResultSupporterBing:
                    model.bleuScore = bingScore;
                    break;
                case TranslateResultSupporterGoogle:
                    model.bleuScore = googleScore;
                    break;
                case TranslateResultSupporterYoudao:
                    model.bleuScore = youdaoScore;
                    break;
                default:
                    break;
            }
        }
        
        [self.translateModelFrameList sortUsingComparator:^NSComparisonResult(ZQTranslateFrame *obj1, ZQTranslateFrame *obj2) {
            return obj1.model.bleuScore < obj2.model.bleuScore;
        }];
        [self systemCombineWithHud:hud];
        
        self.footerView.hidden = YES;
    } else {
        [MBProgressHUD showError:@"译文未全部采集完毕"];
    }
}


#pragma mark - Private
- (void)systemCombineWithHud:(MBProgressHUD *)hud
{
    __block NSMutableArray *array = [NSMutableArray array];
    __block NSMutableString *cnWords = [NSMutableString string];
    __block NSMutableArray *textArray = [NSMutableArray array];
    
    [self.translateModelFrameList enumerateObjectsUsingBlock:^(ZQTranslateFrame *obj, NSUInteger idx, BOOL *stop) {
        if (self.type == TranslateTypeEn2Cn && obj.model.type == TranslateResultSupporterBaidu) {
            [textArray insertObject:obj.model.text atIndex:0];
        } else if (self.type == TranslateTypeCn2En && obj.model.type == TranslateResultSupporterGoogle) {
            [textArray insertObject:obj.model.text atIndex:0];
        } else {
            [textArray addObject:obj.model.text];
        }
    }];
    
    [textArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NSString *each = [obj substringFromIndex:0];
        if (self.type == TranslateTypeEn2Cn) {
            [cnWords appendString:each];
            [cnWords appendString:@"|"];
        } else {
            [array addObject:[each componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        }
    }];
    
    if (self.type == TranslateTypeEn2Cn) {
        [[ZQWordCutTool sharedWordCutTool] cutCNWord:cnWords success:^(NSArray *result) {
            NSLog(@"result = %@", result);
            NSMutableArray *eachSentence = [NSMutableArray array];
            for (NSString *subString in result) {
                if ([subString isEqualToString:@"|"] || ([subString rangeOfString:@"|"].location != NSNotFound)) {
                    [eachSentence addObject:[subString stringByReplacingCharactersInRange:[subString rangeOfString:@"|"] withString:@""]];
                    [array addObject:[eachSentence copy]];
                    [eachSentence removeAllObjects];
                } else {
                    [eachSentence addObject:subString];
                }
            }
            [self handleSentenceArray:array];
            [hud hide:YES];
        } failure:^(NSError *error) {
            [hud hide:YES];
            [MBProgressHUD showError:@"分词服务暂不可使用"];
        }];
    } else {
        [self handleSentenceArray:array];
        [hud hide:YES];
    }
}

- (void)handleRecognizedSentence:(NSNotification *)noti
{
    NSString *text = noti.userInfo[GetRecognizeSentenceNotificationKey];
    NSLog(@"收到通知%@", text);
    ZQTranslateHeaderView *headerView = (ZQTranslateHeaderView *)self.tableView.tableHeaderView;
    [headerView setTextForInput:text];
//    [headerView letInputTextViewBecomeFirstResponder];
}

- (void)handleSentenceArray:(NSArray *)array
{
    NSLog(@"finalSystemCombineArray:%@", array);
    NSString *finalSystemCombine = [[ZQLDPathTool sharedLDPathTool] combineOfFourSentences:array[0] second:array[1] third:array[2] four:array[3] type:self.type];
    NSLog(@"finalSystemCombine = %@", finalSystemCombine);
    
    [self addTranslateFrameToTopWithIcon:@"mt" text:finalSystemCombine srcText:@"猜最优译文是" ofType:TranslateResultSupporterNone score:0];
    [TSMessage showNotificationInViewController:self title:@"译文质量排序完毕" subtitle:nil type:TSMessageNotificationTypeSuccess duration:0.8f canBeDismissedByUser:YES];
    [self.tableView reloadData];
}

- (void)refreshDataWithIcon:(NSString *)icon text:(NSString *)text srcText:(NSString *)srcText ofType:(TranslateResultSupporter)type
{
    [self addTranslateFrameWithIcon:icon text:text srcText:srcText ofType:type score:0];
    [self.tableView reloadData];
}

- (void)addTranslateFrameWithIcon:(NSString *)icon text:(NSString *)text srcText:(NSString *)srcText ofType:(TranslateResultSupporter)type score:(double)score
{
    ZQTranslateModel *model = [[ZQTranslateModel alloc] init];
    model.srcText = [NSString stringWithFormat:@"%@", srcText];
    model.text = [NSString stringWithFormat:@"%@", text];
    model.type = type;
    model.bleuScore = score;
    model.CEorEC = self.type;
    ZQTranslateFrame *modelFrame = [[ZQTranslateFrame alloc] initWithModel:model];
    [self.translateModelFrameList addObject:modelFrame];
}

- (void)addTranslateFrameToTopWithIcon:(NSString *)icon text:(NSString *)text srcText:(NSString *)srcText ofType:(TranslateResultSupporter)type score:(double)score
{
    ZQTranslateModel *model = [[ZQTranslateModel alloc] init];
    model.srcText = [NSString stringWithFormat:@"%@", srcText];
    model.text = [NSString stringWithFormat:@"%@", text];
    model.type = type;
    model.bleuScore = score;
    model.iconName = icon;
    model.CEorEC = self.type;
    ZQTranslateFrame *modelFrame = [[ZQTranslateFrame alloc] initWithModel:model];
    [self.translateModelFrameList insertObject:modelFrame atIndex:0];
}

- (void)hidHudAndShowEvaluaBtn:(MBProgressHUD *)hud
{
    if (self.googleGet && self.baiduGet && self.bingGet && self.youdaoGet) {
        [hud hide:YES];
        self.footerView.hidden = NO;
    }
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

#pragma mark - ZQKeyboardToolViewDelegate
- (void)keyboardToolView:(ZQKeyboardToolView *)toolView didClickVoiceInputBtn:(id)sender
{
    [self quitKb];
    self.footerView.hidden = YES;
    
    ZQVoiceRecognizeViewController *voiceVc = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"ZQVoiceRecognizeViewController"];

    voiceVc.type = self.type;
    [self.navigationController pushViewController:voiceVc animated:YES];
}

- (void)keyboardToolView:(ZQKeyboardToolView *)toolView didClickClearBtn:(id)sender
{
    [self.translateModelFrameList removeAllObjects];
    [self.tableView reloadData];
    [self quitKb];
    [self clearInputField];
}

- (void)singleNoResult:(NSString *)supportor
{
    if (![self dontGetAnything]) { //说明只是Google没有Get
        [MBProgressHUD hideHUD];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD showError:[NSString stringWithFormat:@"%@翻译无结果", supportor]];
        });
    }
}
#pragma mark - ZQTranslateHeaderViewDelegate
- (void)translateHeaderView:(ZQTranslateHeaderView *)headerView didClickTranslateBtn:(id)sender withInput:(NSString *)srcText
{
    if (srcText.length == 0) {
        [MBProgressHUD showError:@"请输入需要翻译的句子！"];
        return;
    }
    self.baiduGet = NO;
    self.bingGet = NO;
    self.youdaoGet = NO;
    self.googleGet = NO;

    self.footerView.hidden = YES;
    [self.translateModelFrameList removeAllObjects];
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"正在加载"];
    
    [ZQTranslateTools googleTranslate:srcText ofType:self.type success:^(NSString *googleResult) {
        self.googleResult = googleResult;
        [self refreshDataWithIcon:@"google.png" text:self.googleResult srcText:srcText ofType:TranslateResultSupporterGoogle];
        self.googleGet = YES;
        [self hidHudAndShowEvaluaBtn:hud];
    } failure:^(NSError *error) {
        [self failed:hud];
        [self singleNoResult:@"Google"];
    }];
    
    [ZQTranslateTools bingTranslate:srcText ofType:self.type success:^(NSString *bingResult) {
        self.bingResult = bingResult;
        [self refreshDataWithIcon:@"biying.png" text:self.bingResult srcText:srcText ofType:TranslateResultSupporterBing];
        self.bingGet = YES;
        [self hidHudAndShowEvaluaBtn:hud];
    } failure:^(NSError *error) {
        [self failed:hud];
        [self singleNoResult:@"Bing"];
    }];
    
    [ZQTranslateTools baiduTranslate:srcText ofType:self.type success:^(ZQBaiduTranslateResult *result) {
        
        ZQBaiduTranslateResultItem *item = result.trans_result[0];
        self.baiduResult = item.dst;
        [self refreshDataWithIcon:@"baidu.png" text:self.baiduResult srcText:srcText ofType:TranslateResultSupporterBaidu];
        
        self.baiduGet = YES;
        [self hidHudAndShowEvaluaBtn:hud];
    } failure:^(NSError *error) {
        [self failed:hud];
        [self singleNoResult:@"Baidu"];
    }];
    
    [ZQTranslateTools youdaoTranslate:srcText ofType:self.type success:^(ZQYoudaoTranslateResult *youdaoResult) {
        self.youdaoResult = youdaoResult.translation.firstObject;
        [self refreshDataWithIcon:@"youdao.png" text:self.youdaoResult srcText:srcText ofType:TranslateResultSupporterYoudao];
        self.youdaoGet = YES;
        [self hidHudAndShowEvaluaBtn:hud];
    } failure:^(NSError *error) {
        [self failed:hud];
        [self singleNoResult:@"Youdao"];
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


@end
