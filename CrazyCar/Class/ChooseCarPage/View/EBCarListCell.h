//
//  EBCarListCell.h
//  CrazyCar
//
//  Created by Edward on 16/3/1.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EBCarModel;

@interface EBCarListCell : UITableViewCell

@property (nonatomic,strong) UIImageView *iconImage;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) EBCarModel *model;

@end
