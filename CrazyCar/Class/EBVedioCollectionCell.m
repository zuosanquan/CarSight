//
//  EBVedioCollectionCell.m
//  CrazyCar
//
//  Created by Edward on 16/3/3.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBVedioCollectionCell.h"
#import "EBVedioModel.h"

@interface EBVedioCollectionCell()

@property (nonatomic, strong) UIImageView *vedioImage;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *totalVisitLabel;

@property (nonatomic, strong) UILabel *durationLabel;

@end

@implementation EBVedioCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void) setupUI{
    CGFloat marginH = 7;
    CGFloat marginB = 8;
    CGFloat picW = 17;
    self.vedioImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, marginB, CGRectGetWidth(self.contentView.frame), (CGRectGetHeight(self.contentView.frame) - marginH) * 3 / 5)];
    [self.contentView addSubview:self.vedioImage];
    
    CGFloat WH = CGRectGetHeight(_vedioImage.frame) / 5 ;
    UIImageView *littleImage = [[UIImageView alloc] initWithFrame:CGRectMake(3, CGRectGetHeight(_vedioImage.frame) - WH - 3, WH, WH)];
    littleImage.image = [UIImage imageNamed:@"Oval 1 + Triangle 1"];
    [self.vedioImage addSubview:littleImage];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.vedioImage.frame), CGRectGetMaxY(self.vedioImage.frame) + marginB, CGRectGetWidth(self.vedioImage.frame), CGRectGetHeight(self.vedioImage.frame) / 3 )];
    [self.contentView addSubview:self.titleLabel];
    
    self.totalVisitLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame) + picW, CGRectGetMaxY(self.titleLabel.frame) + marginB, CGRectGetWidth(self.contentView.frame) / 2 - picW, CGRectGetHeight(self.titleLabel.frame) / 2)];
    [self.contentView addSubview:self.totalVisitLabel];
    
    self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.totalVisitLabel.frame) + picW, CGRectGetMaxY(self.titleLabel.frame) + marginB, CGRectGetWidth(self.contentView.frame) / 2 - picW, CGRectGetHeight(self.titleLabel.frame) / 2)];
    [self.contentView addSubview:self.durationLabel];
}

- (void)setModel:(EBVedioModel *)model{
    _model = model;
    
    if ([model.ImageLink containsString:@"{0}"]) {
        model.ImageLink = [model.ImageLink stringByReplacingOccurrencesOfString:@"{0}" withString:@"360"];
    }
    if ([model.ImageLink containsString:@"{1}"]) {
        model.ImageLink = [model.ImageLink stringByReplacingOccurrencesOfString:@"{1}" withString:@"0"];
    }
    [self.vedioImage sd_setImageWithURL:[NSURL URLWithString:model.ImageLink] placeholderImage:[UIImage imageNamed:@"movie_default_light_760x570"]];
    
    self.titleLabel.text = model.Title;
    self.titleLabel.textColor = [UIColor cellOtherContentColor];
    self.titleLabel.font = [UIFont headViewNormalTextFont];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    NSString *visits = nil;
    if (model.TotalVisit >= 10000) {
        NSInteger wan = model.TotalVisit / 10000;
        NSInteger throunds = model.TotalVisit % 1000 / 1000;
        visits = [NSString stringWithFormat:@"%ld.%ld万",wan,throunds];
    }else{
        visits = [NSString stringWithFormat:@"%ld",model.TotalVisit];
    }
    
    self.totalVisitLabel.text = visits;
    self.totalVisitLabel.font = [UIFont headViewSmallFont];
    self.totalVisitLabel.textColor = [UIColor cellOtherContentColor];
    self.totalVisitLabel.adjustsFontSizeToFitWidth = YES;
    
    CGFloat playWH = CGRectGetHeight(self.totalVisitLabel.frame) / 2;
    UIImageView *play = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMidY(self.totalVisitLabel.frame) - playWH / 2, playWH, playWH)];
    play.image = [UIImage imageNamed:@"Triangle 3"];
    [self.contentView addSubview:play];
    
    self.durationLabel.text = model.Duration;
    self.durationLabel.font = [UIFont headViewSmallFont];
    self.durationLabel.userInteractionEnabled = false;
    self.durationLabel.textColor = [UIColor cellOtherContentColor];
    self.durationLabel.adjustsFontSizeToFitWidth = YES;
    
    CGFloat timeWH = CGRectGetHeight(self.durationLabel.frame) / 1.5;
    UIImageView *time = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.totalVisitLabel.frame), CGRectGetMidY(self.totalVisitLabel.frame) - timeWH / 2, timeWH, timeWH)];
    time.image = [UIImage imageNamed:@"emoji_keybord_clock_icon"];
    [self.contentView addSubview:time];
    
    
}
@end
