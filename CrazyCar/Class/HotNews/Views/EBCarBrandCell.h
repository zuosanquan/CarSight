//
//  EBCarBrandCell.h
//  CrazyCar
//
//  Created by Edward on 16/3/2.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EBCarlistModel;

@interface EBCarBrandCell : UITableViewCell

@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) UILabel *minPriceLabel;

@property (nonatomic, strong) UILabel *transLabel;

@property (nonatomic, strong) UILabel *referPriceLabel;

@property (nonatomic, strong) EBCarlistModel *listModel;

@end
