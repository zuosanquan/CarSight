//
//  EBCarBrandHeadView.m
//  CrazyCar
//
//  Created by Edward on 16/3/2.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBCarBrandHeadView.h"
#import "EBCarBrandModel.h"

@implementation EBCarBrandHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.7];
        [self setup];
    }
    return self;
}

- (void) setup{
    CGFloat marginW = 10;
    CGFloat marginH = 5;
    CGFloat margin = 3;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, (CGRectGetHeight(self.frame) - marginW -margin) * 7 / 8)];
    [self addSubview:self.imageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(morePicture:)];
    self.imageView.userInteractionEnabled = true;
    [self.imageView addGestureRecognizer:tap];
    
    self.currentPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginW, CGRectGetMaxY(self.imageView.frame) + marginH, (WIDTH - 2 * marginW) / 2, CGRectGetHeight(self.frame) / 16)];
    
    [self addSubview:self.currentPriceLabel];
    
    self.lastPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.currentPriceLabel.frame), CGRectGetMaxY(self.currentPriceLabel.frame) + margin, CGRectGetWidth(self.currentPriceLabel.frame), CGRectGetHeight(self.currentPriceLabel.frame))];
    [self addSubview:self.lastPriceLabel];
    
    self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.currentPriceLabel.frame), CGRectGetMinY(self.currentPriceLabel.frame), CGRectGetWidth(self.currentPriceLabel.frame), CGRectGetHeight(self.currentPriceLabel.frame))];
    self.locationLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.locationLabel];
    
    self.oilLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.locationLabel.frame), CGRectGetMaxY(self.locationLabel.frame) + margin, CGRectGetWidth(self.locationLabel.frame), CGRectGetHeight(self.locationLabel.frame))];
    self.oilLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.oilLabel];
}

- (void)setModel:(EBCarBrandModel *)model{
    _model = model;
    if ([model.coverImg containsString:@"{0}"]) {
       model.coverImg = [model.coverImg stringByReplacingOccurrencesOfString:@"{0}" withString:@"3"];
    }
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.coverImg]]];
//    [self.imageView addScaleAvariabilityImageWithImage:model.coverImg andHeight:CGRectGetHeight(self.imageView.frame)];
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.coverImg] placeholderImage:[UIImage imageNamed:@"Icon-60"]];
    self.currentPriceLabel.text = model.guidePriceRange;
    self.currentPriceLabel.textColor = [UIColor redColor];
    self.currentPriceLabel.font = [UIFont headViewColorTextFont];
    
     NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:model.referencePriceRange];
    [attri addAttribute:  NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, model.referencePriceRange.length)];
//    [attri addAttribute:NSStrikethroughColorAttributeName
//                  value:[UIColor grayColor] range:NSMakeRange(0, model.referencePriceRange.length)];
    self.lastPriceLabel.attributedText = attri;
    self.lastPriceLabel.font = [UIFont headViewSmallFont];
    self.lastPriceLabel.textColor = [UIColor cellOtherContentColor];
    
    self.locationLabel.text = [NSString stringWithFormat:@"%@ %@",model.country,model.carType];
    self.locationLabel.font = [UIFont headViewNormalTextFont];
    self.locationLabel.textColor = [UIColor cellOtherContentColor];
    
    self.oilLabel.text = [NSString stringWithFormat:@"油耗%@",model.oil];
    self.oilLabel.font = [UIFont headViewNormalTextFont];
    self.oilLabel.textColor = [UIColor cellOtherContentColor];
}

- (void) morePicture:(UITapGestureRecognizer *)tap {
    if ([self.delegate conformsToProtocol:@protocol(EBCarBrandHeadViewDelegate)]) {
        [self.delegate findMorePicture];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
