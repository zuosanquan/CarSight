//
//  EBHotNewsTableCell.h
//  CrazyCar
//
//  Created by Edward on 16/2/29.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EBHotNewModel;

@interface EBHotNewsTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageiew;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *srcLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (nonatomic,strong) EBHotNewModel *model;

@end
