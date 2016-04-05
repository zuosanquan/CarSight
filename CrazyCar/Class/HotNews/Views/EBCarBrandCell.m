//
//  EBCarBrandCell.m
//  CrazyCar
//
//  Created by Edward on 16/3/2.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBCarBrandCell.h"
#import "EBCarGroupModel.h"

@implementation EBCarBrandCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void) setupUI{
    CGFloat marginW = 10;
    CGFloat marginH = 10;
    CGFloat marginB = 7;
    self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginW, marginH, (WIDTH - 2 * marginW) * 2 / 3, (100 - 2 * marginH - marginB) / 2)];
    [self.contentView addSubview:self.typeLabel];
    
    self.transLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.typeLabel.frame), CGRectGetMaxY(self.typeLabel.frame) + marginB, CGRectGetWidth(self.typeLabel.frame), CGRectGetHeight(self.typeLabel.frame))];
    [self.contentView addSubview:self.transLabel];
    
    self.minPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.typeLabel.frame), CGRectGetMinY(self.typeLabel.frame), (WIDTH - 2 * marginW) / 3, CGRectGetHeight(self.typeLabel.frame))];
    [self.contentView addSubview:self.minPriceLabel];
    
    self.referPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.typeLabel.frame), CGRectGetMaxY(self.typeLabel.frame) + marginB, (WIDTH - 2 * marginW) / 3, CGRectGetHeight(self.typeLabel.frame))];
    [self.contentView addSubview:self.referPriceLabel];
}

- (void)setListModel:(EBCarlistModel *)listModel{
    _listModel = listModel;
    
    self.typeLabel.text = [NSString stringWithFormat:@"%@款 %@",listModel.Year,listModel.Name];
    self.typeLabel.font = [UIFont headViewColorTextFont];
    
    self.transLabel.text = listModel.Trans;
    self.transLabel.font = [UIFont headViewNormalTextFont];
    self.transLabel.textColor = [UIColor cellOtherContentColor];
    
    if (listModel.MinPrice.length == 0) {
        self.minPriceLabel.text = @"暂无报价";
    }else{
        self.minPriceLabel.text = [NSString stringWithFormat:@"%@起",listModel.MinPrice];
    }
    self.minPriceLabel.textColor = [UIColor redColor];
    self.minPriceLabel.textAlignment = NSTextAlignmentRight;
    self.minPriceLabel.font = [UIFont headViewNormalTextFont];
    
    self.referPriceLabel.text = [NSString stringWithFormat:@"指导价:%@",listModel.ReferPrice];
    self.referPriceLabel.textColor = [UIColor cellOtherContentColor];
    self.referPriceLabel.font = [UIFont headViewNormalTextFont];
    self.referPriceLabel.textAlignment = NSTextAlignmentRight;
}

@end
