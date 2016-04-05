//
//  EBCarBrandHeadView.h
//  CrazyCar
//
//  Created by Edward on 16/3/2.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EBCarBrandModel;

@protocol EBCarBrandHeadViewDelegate <NSObject>

- (void) findMorePicture;

@end

@interface EBCarBrandHeadView : UIView

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UILabel *currentPriceLabel;

@property (nonatomic,strong) UILabel *lastPriceLabel;

@property (nonatomic,strong) UILabel *locationLabel;

@property (nonatomic,strong) UILabel *oilLabel;

@property (nonatomic,strong) EBCarBrandModel *model;

@property (nonatomic, weak) id<EBCarBrandHeadViewDelegate> delegate;
@end
