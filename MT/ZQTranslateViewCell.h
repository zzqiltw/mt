//
//  ZQTranslateViewCell.h
//  MT
//
//  Created by zzqiltw on 14-12-28.
//  Copyright (c) 2014年 zzqiltw. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  每一个cell
 */
#import "ZQTranslateFrame.h"
#define TranslateCellID @"TranslateCellID"

@interface ZQTranslateViewCell : UITableViewCell

@property (nonatomic, strong) ZQTranslateFrame *translateFrame;

@end
