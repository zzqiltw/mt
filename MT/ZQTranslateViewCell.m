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
@property (nonatomic, weak) UIView *sepaView;

@end

@implementation ZQTranslateViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *translateText = [[UILabel alloc] init];
        translateText.numberOfLines = 0;
//        translateText.textAlignment = NSTextAlignmentCenter;
        translateText.lineBreakMode = NSLineBreakByWordWrapping;
        translateText.font = TextFont;
        [self.contentView addSubview:translateText];
        self.translateText = translateText;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.clipsToBounds = YES;
        imageView.layer.borderColor = [[UIColor colorWithRed:30/255.0 green:164/255.0 blue:160/255.0 alpha:1.0f] CGColor];
        imageView.layer.borderWidth = 1.0f;
        [self.contentView addSubview:imageView];
        self.icon = imageView;
        
        UIView *sepaView = [[UIView alloc] init];
        sepaView.backgroundColor = [UIColor colorWithRed:30/255.0 green:164/255.0 blue:160/255.0 alpha:0.5f];
        sepaView.alpha = 0.5f;
        [self.contentView addSubview:sepaView];
        self.sepaView = sepaView;
        
        [self setupBg];
    }
    return self;
}

- (UIImageView *)bgView
{
    if (_bgView == nil) {
        UIImage *bgImage = [UIImage imageNamed:@"cellBg2"];

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
    self.icon.layer.cornerRadius = self.icon.frame.size.width * 0.5f;
    self.translateText.frame = self.translateFrame.textFrame;
    self.sepaView.frame = CGRectMake(0, 0, self.frame.size.width, 1);
}


@end
