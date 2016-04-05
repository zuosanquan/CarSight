//
//  EBCarEachBrandController.h
//  CrazyCar
//
//  Created by Edward on 16/3/2.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EBCarSeriallist;

@interface EBCarEachBrandController : UIViewController

@property (nonatomic,strong) EBCarSeriallist *model;

@property (nonatomic, assign) NSInteger seriseId;

@property (nonatomic, assign) BOOL isCollected;

@property (nonatomic, assign) BOOL isSearch;

@end
