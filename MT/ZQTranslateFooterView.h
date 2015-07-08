//
//  ZQTranslateFooterView.h
//  MT
//
//  Created by zzqiltw on 15-3-30.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

/**
 *  翻译界面底部的评价按钮
 */
#import <UIKit/UIKit.h>
#define ZQFooterViewHeight 30
@class ZQTranslateFooterView;

@protocol ZQTranslateFooterViewDelegate <NSObject>

@optional
- (void)footerView:(ZQTranslateFooterView *)footerView didClickButton:(UIButton *)button;

@end
@interface ZQTranslateFooterView : UIView

@property (nonatomic, weak) id<ZQTranslateFooterViewDelegate> delegate;

@end
