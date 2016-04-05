//
//  EBPictureTableCell.m
//  CrazyCar
//
//  Created by Edward on 16/3/9.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBPictureTableCell.h"
#import "EBPictureModel.h"

@implementation EBPictureTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andGroups:(EBPictureGroup *)models{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI:models];
    }
    return self;
}

- (void)creatUI:(EBPictureGroup *)models{
    CGFloat marginX = 10;
    CGFloat marginW = 5;
    CGFloat marginY = marginX;
    CGFloat marginH = marginW;
    CGFloat W = (WIDTH - 2 * (marginX + marginW)) / 3;
    CGFloat H = (HEIGHT / 4 - 2 * marginY - marginH) / 2;
    for (int i = 0; i < models.Images.count; i++) {
        UIImageView *iamgeView = [[UIImageView alloc] initWithFrame:CGRectMake((i % 3) * (W + marginW) + marginX, (i / 3) * (H + marginH) + marginY, W, H)];
        iamgeView.tag = i + 900;
        iamgeView.userInteractionEnabled = YES;
        iamgeView.clipsToBounds = YES;
        [self.contentView addSubview:iamgeView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onIap:)];
        [iamgeView addGestureRecognizer:tap];
    }
    //没有数据时，设置占位图
    if (models.Images.count == 0) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(marginX, marginY, WIDTH - 2 * marginX, HEIGHT / 4 - 2 * marginY)];
        imageview.image = [UIImage imageNamed:@"pic_placeholder"];
        [self.contentView addSubview:imageview];
        
        
    }
}

- (void)setModels:(EBPictureGroup *)models{
    _models = models;
    
    for (int i = 0; i < models.Images.count; i++) {
        UIImageView *iamgeView = (UIImageView *)[self.contentView viewWithTag:i + 900];
        EBImagesModel *imageModel = models.Images[i];
        if ([imageModel.imageUrl containsString:@"{0}"]) {
            imageModel.imageUrl = [imageModel.imageUrl stringByReplacingOccurrencesOfString:@"{0}" withString:@"3"];
        }
        [iamgeView sd_setImageWithURL:[NSURL URLWithString:imageModel.imageUrl] placeholderImage:[UIImage imageNamed:@"pic_placeholder"]];
        
    }
    

}

- (void)onIap:(UITapGestureRecognizer *)tap{
    UIImageView *imageView = (UIImageView *)tap.view;
    EBImagesModel *imageModel = _models.Images[imageView.tag - 900];
    if ([imageModel.imageUrl containsString:@"{0}"]) {
        imageModel.imageUrl = [imageModel.imageUrl stringByReplacingOccurrencesOfString:@"{0}" withString:@"3"];
    }
    if ([self.largeDelegate conformsToProtocol:@protocol(EBPictureTableCellChangeDelegate)]) {
        [self.largeDelegate enlargeImage:imageView.image withUrl:imageModel.imageUrl];
    }
}

@end
