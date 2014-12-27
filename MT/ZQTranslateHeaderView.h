//
//  ZQTranslateHeaderView.h
//  MT
//
//  Created by zzqiltw on 14-12-27.
//  Copyright (c) 2014年 zzqiltw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZQKeyboardToolView.h"

@protocol ZQTranslateHeaderViewDelegate;

@interface ZQTranslateHeaderView : UIView

@property (nonatomic, copy) NSString *modeType;
@property (nonatomic, weak) id<ZQTranslateHeaderViewDelegate> delegate;

@end

@protocol ZQTranslateHeaderViewDelegate <NSObject>

@optional
- (void)translateHeaderView:(ZQTranslateHeaderView *)headerView didClickTranslateBtn:(id)sender;

@end
