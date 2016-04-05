//
//  EBCarTableViewCell.h
//  CrazyCar
//
//  Created by Edward on 16/2/29.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBCarTableViewCell : UITableViewCell
/**图片*/
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/**名称*/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**价格*/
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
