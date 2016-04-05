//
//  EBHotNewsTableCell.m
//  CrazyCar
//
//  Created by Edward on 16/2/29.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBHotNewsTableCell.h"
#import "EBHotNewModel.h"
#import "CarHeader.h"
#import <UIImageView+WebCache.h>
@implementation EBHotNewsTableCell

- (void)awakeFromNib {
    
}

- (void)setModel:(EBHotNewModel *)model{
    _model = model;
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    if (model.type == 3) {
        [self creatViewWithModel:model];
    }else{
        [self creatNormalViewWithModel:model];
    }
}

- (void)creatViewWithModel:(EBHotNewModel *)model{
    CGFloat eachH;
    if ([model.picCover containsString:@";"]) {
        eachH = kHotNewCellHeight / 5;
    }else{
        eachH = 3 * kHotNewCellNormalHeight / 5;
    }
    CGFloat marginW = 10;
    CGFloat marginH = 5;
    CGFloat margin = 5;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginW, marginH, WIDTH, eachH)];
    titleLabel.text = model.title;
    [self.contentView addSubview:titleLabel];
    
    if ([model.picCover containsString:@";"]) {
        NSArray *strArr = [model.picCover componentsSeparatedByString:@";"];
        
        CGFloat W = (WIDTH - (strArr.count - 1) * margin - 2 * marginW) / strArr.count;
        [strArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(idx * (W + margin) + marginW , CGRectGetMaxY(titleLabel.frame), W, eachH * 3)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:strArr[idx]] placeholderImage:[UIImage sd_animatedGIFNamed:@"car_loading.gif"]];
            [self.contentView addSubview:imageView];
        }];
    }else{
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(marginW , CGRectGetMaxY(titleLabel.frame), WIDTH - 2 * marginW, eachH * 3)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.picCover] placeholderImage:[UIImage sd_animatedGIFNamed:@"car_loading.gif"]];
        [self.contentView addSubview:imageView];
    }
    
    UILabel *srcLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginW,eachH * 4, (WIDTH - marginW * 2 - margin) / 2, eachH)];
    srcLabel.textAlignment = NSTextAlignmentLeft;
    srcLabel.text = model.src;
    srcLabel.font = [UIFont systemFontOfSize:kHotNewCellSmallTitleFont];
    srcLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:srcLabel];
    
    UILabel *commentCount = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(srcLabel.frame) + margin, CGRectGetMinY(srcLabel.frame), WIDTH - CGRectGetMaxX(srcLabel.frame) - marginW,eachH)];
    commentCount.textAlignment = NSTextAlignmentRight;
    commentCount.text = [NSString stringWithFormat:@"%ld",model.commentCount];
    commentCount.font = [UIFont systemFontOfSize:kHotNewCellSmallTitleFont];
    commentCount.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:commentCount];
}

- (void)creatNormalViewWithModel:(EBHotNewModel *)model{
    CGFloat cellH = kHotNewCellNormalHeight;
    CGFloat eachW = WIDTH / 4;
    CGFloat marginW = 10;
    CGFloat marginH = 8;
    CGFloat margin = 5;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(marginW, marginH, eachW, cellH - 2 * marginH)];
    if ([model.picCover containsString:@"{0}"] || [model.picCover containsString:@"{1}"]) {
        model.picCover = [model.picCover stringByReplacingOccurrencesOfString:@"{0}" withString:@"180"];
        model.picCover = [model.picCover stringByReplacingOccurrencesOfString:@"{1}" withString:@"0"];
    }
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.picCover] placeholderImage:[UIImage imageNamed:@"pic_placeholder"]];
    [self.contentView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + margin, CGRectGetMinY(imageView.frame),WIDTH - CGRectGetMaxX(imageView.frame) - marginW, CGRectGetHeight(imageView.frame) * 2 / 3)];
    titleLabel.numberOfLines = 0;
    titleLabel.text = model.title;
    [self.contentView addSubview:titleLabel];
    
    UILabel *srcLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame),CGRectGetMaxY(imageView.frame) - 10, WIDTH / 3, 10)];
    srcLabel.textAlignment = NSTextAlignmentLeft;
    if (model.src.length == 0) {
        srcLabel.text = model.mediaName;
    }else{
        srcLabel.text = model.src;
    }
    
    srcLabel.font = [UIFont systemFontOfSize:kHotNewCellSmallTitleFont];
    srcLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:srcLabel];
    
    UILabel *comCount = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(srcLabel.frame),CGRectGetMinY(srcLabel.frame), WIDTH - marginW - CGRectGetMaxX(srcLabel.frame), 10)];
    comCount.textAlignment = NSTextAlignmentRight;
    comCount.text = [NSString stringWithFormat:@"%ld",model.commentCount];
    comCount.font = [UIFont systemFontOfSize:kHotNewCellSmallTitleFont];
    comCount.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:comCount];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
