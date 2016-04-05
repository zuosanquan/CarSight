//
//  EBCarListCell.m
//  CrazyCar
//
//  Created by Edward on 16/3/1.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBCarListCell.h"

@implementation EBCarListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, CGRectGetHeight(self.contentView.frame) - 10, CGRectGetHeight(self.contentView.frame) - 10)];
        [self.contentView addSubview:self.iconImage];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImage.frame) + 10, CGRectGetMinY(_iconImage.frame), WIDTH - 20 - CGRectGetWidth(_iconImage.frame), CGRectGetHeight(_iconImage.frame))];
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

@end
