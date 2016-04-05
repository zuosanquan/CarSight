//
//  CellFrame.h
//  CrazyCar
//
//  Created by Edward on 16/2/29.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class EBHotNewModel;

@interface CellFrame : NSObject

@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,strong) EBHotNewModel *model;

@end
