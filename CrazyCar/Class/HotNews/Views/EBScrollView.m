//
//  EBScrollView.m
//  CrazyCar
//
//  Created by Edward on 16/3/1.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBScrollView.h"
#import "EBHotNewModel.h"

@implementation EBScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, CGRectGetHeight(frame))];
        [self addSubview:_imageView];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetHeight(frame) - 13, WIDTH, 10)];
        _label.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"headtab_bottom_shadow"] stretchableImageWithLeftCapWidth:1 topCapHeight:0.01]];
        [self addSubview:_label];
        
    }
    return self;
}

- (void)setModel:(EBHotNewModel *)model{
    _model = model;

    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_model.picCover] placeholderImage:[UIImage imageNamed:@"pic_placeholder"]];
    self.label.text = _model.title;
    self.label.font = [UIFont systemFontOfSize:14];
    self.label.textColor = [UIColor whiteColor];
//    self.label.backgroundColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:0.6];
}

@end
