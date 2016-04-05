//
//  EBScrollView.h
//  CrazyCar
//
//  Created by Edward on 16/3/1.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EBHotNewModel;

@interface EBScrollView : UIView

@property (nonatomic,strong) EBHotNewModel *model;

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UILabel *label;

@end
