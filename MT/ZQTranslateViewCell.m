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
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (nonatomic, strong) UIImageView *bgView;

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

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupBg];
    
    UILabel *translateText = [[UILabel alloc] init];
    translateText.numberOfLines = 0;
    translateText.frame = CGRectMake(59, 10, 0, 0);
    translateText.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:translateText];
    self.translateText = translateText;
}

- (void)setupBg
{
    self.backgroundColor = [UIColor clearColor];
    
//    self.backgroundView = self.bgView;
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
    
    CGSize labelsize = [self.translateText.text sizeWithFont:self.translateText.font     constrainedToSize:CGSizeMake(320, 200) lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"before%@", NSStringFromCGRect(self.translateText.frame));
    self.translateText.frame = CGRectMake(self.translateText.frame.origin.x, self.translateText.frame.origin.y, labelsize.width, labelsize.height);
    NSLog(@"after%@", NSStringFromCGRect(self.translateText.frame));
    self.translateText.backgroundColor = [UIColor redColor];
}


@end
