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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ZQTranslateViewCell" owner:nil options:nil] lastObject];
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell"]];
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        self.bgView = imageView;
//        [self addSubview:self.bgView];
        self.backgroundView = nil;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell"]];
    }
    return self;
}

- (void)setModel:(ZQTranslateModel *)model
{
    _model = model;
    
    self.icon.image = [UIImage imageNamed:model.iconName];
    self.translateText.text = model.text;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.bgView.frame = self.frame;
}

@end
