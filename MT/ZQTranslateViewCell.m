//
//  ZQTranslateViewCell.m
//  MT
//
//  Created by zzqiltw on 14-12-28.
//  Copyright (c) 2014年 zzqiltw. All rights reserved.
//

#import "ZQTranslateViewCell.h"
#import "UIImage+IW.h"

@interface ZQTranslateViewCell ()

@property (nonatomic, weak) UILabel *srcText;
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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *srcTextLabel = [[UILabel alloc] init];
        srcTextLabel.numberOfLines = 0;
        srcTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        srcTextLabel.font = TextFont;
        srcTextLabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.8];
        [self.contentView addSubview:srcTextLabel];
        self.srcText = srcTextLabel;
        
        UILabel *translateText = [[UILabel alloc] init];
        translateText.numberOfLines = 0;
//        translateText.textAlignment = NSTextAlignmentCenter;
        translateText.lineBreakMode = NSLineBreakByWordWrapping;
        translateText.font = TextFont;
        translateText.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:translateText];
        self.translateText = translateText;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.clipsToBounds = YES;
        imageView.layer.borderColor = [[UIColor colorWithRed:30/255.0 green:164/255.0 blue:160/255.0 alpha:1.0f] CGColor];
        imageView.layer.borderWidth = 1.0f;
        [self.contentView addSubview:imageView];
        self.icon = imageView;
        
//        UIView *sepaView = [[UIView alloc] init];
//        sepaView.backgroundColor = [UIColor colorWithRed:30/255.0 green:164/255.0 blue:160/255.0 alpha:0.5f];
//        sepaView.alpha = 0.5f;
//        [self.contentView addSubview:sepaView];
//        self.sepaView = sepaView;
        
        [self setupBg];
    }
    return self;
}

- (UIImageView *)bgView
{
    if (_bgView == nil) {
        UIImage *bgImage = [UIImage resizedImage:@"common_card_middle_background"];

        UIImageView *imageView = [[UIImageView alloc] initWithImage:bgImage];
        imageView.frame = self.frame;
        _bgView = imageView;
    }
    
    return _bgView;
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = 3;
    frame.origin.y += 3;
    frame.size.width -= 6;
    frame.size.height -= 6;
    [super setFrame:frame];
}
- (void)setupBg
{
    self.backgroundColor = [UIColor clearColor];
    self.bgView = nil;
    [self insertSubview:self.bgView atIndex:0];
}

- (void)setTranslateFrame:(ZQTranslateFrame *)translateFrame
{
    _translateFrame = translateFrame;
    
    self.icon.image = [UIImage imageNamed:translateFrame.model.iconName];
    self.translateText.text = translateFrame.model.text;
    self.srcText.text = translateFrame.model.srcText;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.icon.frame = self.translateFrame.iconFrame;
    self.icon.layer.cornerRadius = self.icon.frame.size.width * 0.5f;
    self.translateText.frame = self.translateFrame.textFrame;
    self.srcText.frame = self.translateFrame.srcTextFrame;
//    self.sepaView.frame = CGRectMake(0, 0, self.frame.size.width, 1);
    self.bgView.frame = self.translateFrame.bgFrame;
}


@end
