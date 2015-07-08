//
//  ZQTranslateHeaderView.h
//  MT
//
//  Created by zzqiltw on 14-12-27.
//  Copyright (c) 2014年 zzqiltw. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZQTranslateHeaderViewDelegate;

/**
 *  翻译页面上面的输入框
 */
@interface ZQTranslateHeaderView : UIView

@property (nonatomic, assign) TranslateType modeType;
@property (nonatomic, weak) id<ZQTranslateHeaderViewDelegate> delegate;

/**
 *  设置要翻译的文字
 *
 *  @param text <#text description#>
 */
- (void)setTextForInput:(NSString *)text;

/**
 *  暂时没有用到这个方法
 *
 *  @param inputAccessoryView <#inputAccessoryView description#>
 */
- (void)setInputFieldAccessoryView:(UIView *)inputAccessoryView;

/**
 *  退下键盘
 */
- (void)quitKb;

/**
 *  清空输入
 */
- (void)clearInputField;

/**
 *  让输入框变成第一响应者
 */
- (void)letInputTextViewBecomeFirstResponder;

@end

@protocol ZQTranslateHeaderViewDelegate <NSObject>

@optional
- (void)translateHeaderView:(ZQTranslateHeaderView *)headerView didClickTranslateBtn:(id)sender withInput:(NSString *)srcText;

@end
