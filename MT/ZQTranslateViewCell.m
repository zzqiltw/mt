//
//  ZQTranslateViewCell.m
//  MT
//
//  Created by zzqiltw on 14-12-28.
//  Copyright (c) 2014年 zzqiltw. All rights reserved.
//

#import "ZQTranslateViewCell.h"

@interface ZQTranslateViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *translateText;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (nonatomic, weak) UIImageView *bgView;

@end

@implementation ZQTranslateViewCell

/**
 这个方法好像没有调用耶- -
 
 :param: idinitWithStyle <#idinitWithStyle description#>
 */
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        self = [[[NSBundle mainBundle] loadNibNamed:@"ZQTranslateViewCell" owner:nil options:nil] lastObject];
//        [self setupBg];
//    }
//    return self;
//}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupBg];
}

- (void)setupBg
{
    self.backgroundView = nil;
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
//    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellbg"]];
    
}

- (void)setModel:(ZQTranslateModel *)model
{
    _model = model;
    
    self.icon.image = [UIImage imageNamed:model.iconName];
    self.translateText.text = model.text;
}


@end
