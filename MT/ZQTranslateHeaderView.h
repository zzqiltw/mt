//
//  ZQTranslateHeaderView.h
//  MT
//
//  Created by zzqiltw on 14-12-27.
//  Copyright (c) 2014年 zzqiltw. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZQTranslateHeaderViewDelegate;

@interface ZQTranslateHeaderView : UIView

@property (nonatomic, copy) NSString *modeType;
@property (nonatomic, weak) id<ZQTranslateHeaderViewDelegate> delegate;

- (void)setTextForInput:(NSString *)text;
- (void)setInputFieldAccessoryView:(UIView *)inputAccessoryView;
- (void)quitKb;
- (void)clearInputField;

@end

@protocol ZQTranslateHeaderViewDelegate <NSObject>

@optional
- (void)translateHeaderView:(ZQTranslateHeaderView *)headerView didClickTranslateBtn:(id)sender withInput:(NSString *)srcText;

@end
