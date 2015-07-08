//
//  ZQKeyboardToolView.h
//  MT
//
//  Created by zzqiltw on 14-12-27.
//  Copyright (c) 2014年 zzqiltw. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  键盘工具条（和键盘一起拉上来的）
 */
@protocol ZQKeyboardToolViewDelegate;

@interface ZQKeyboardToolView : UIView
@property (nonatomic, weak) id<ZQKeyboardToolViewDelegate> delegate;

- (IBAction)clearAll:(id)sender;



@end

@protocol ZQKeyboardToolViewDelegate <NSObject>

@optional
- (void)keyboardToolView:(ZQKeyboardToolView *)toolView didClickVoiceInputBtn:(id)sender;
- (void)keyboardToolView:(ZQKeyboardToolView *)toolView didClickClearBtn:(id)sender;

@end