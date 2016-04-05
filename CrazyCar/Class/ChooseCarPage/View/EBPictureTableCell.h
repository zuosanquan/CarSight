//
//  EBPictureTableCell.h
//  CrazyCar
//
//  Created by Edward on 16/3/9.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBPictureModel.h"

@protocol EBPictureTableCellChangeDelegate <NSObject>

- (void) enlargeImage:(UIImage *)image withUrl:(NSString *)imageUrl;

@end

@interface EBPictureTableCell : UITableViewCell

@property (nonatomic, strong) EBPictureGroup *models;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andGroups:(EBPictureGroup *)models;

@property (nonatomic, weak) id<EBPictureTableCellChangeDelegate> largeDelegate;
@end
