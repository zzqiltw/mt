//
//  ZQTranslateViewCell.m
//  MT
//
//  Created by zzqiltw on 14-12-28.
//  Copyright (c) 2014年 zzqiltw. All rights reserved.
//

#import "ZQTranslateViewCell.h"

@interface ZQTranslateViewCell ()

@property (weak, nonatomic) UILabel *translateText;
@property (weak, nonatomic) UIImageView *icon;
@property (nonatomic, strong) UIImageView *bgView;

@end

@implementation ZQTranslateViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *translateText = [[UILabel alloc] init];
        translateText.numberOfLines = 0;
        translateText.textAlignment = NSTextAlignmentCenter;
        translateText.lineBreakMode = NSLineBreakByWordWrapping;
        translateText.font = TextFont;
        [self.contentView addSubview:translateText];
        self.translateText = translateText;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        self.icon = imageView;
        
        [self setupBg];
    }
    return self;
}

- (UIImageView *)bgView
{
    if (_bgView == nil) {
        UIImage *bgImage = [UIImage imageNamed:@"cellBg2"];
        [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(15, 160, 0, 0)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:bgImage];
        imageView.frame = self.frame;
        _bgView = imageView;
    }
    
    return _bgView;
}


- (void)setupBg
{
    self.backgroundColor = [UIColor clearColor];
    
//    self.backgroundView = self.bgView;
}

- (void)setTranslateFrame:(ZQTranslateFrame *)translateFrame
{
    _translateFrame = translateFrame;
    
    self.icon.image = [UIImage imageNamed:translateFrame.model.iconName];
    self.translateText.text = translateFrame.model.text;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.icon.frame = self.translateFrame.iconFrame;
    self.translateText.frame = self.translateFrame.textFrame;
}


@end
