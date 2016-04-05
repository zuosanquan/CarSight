//
//  EBRightViewController.h
//  CrazyCar
//
//  Created by Edward on 16/2/29.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBRightViewController : UIViewController

@property (nonatomic,assign) NSInteger masterid;

@property (nonatomic,copy) NSString *logUrl;

@property (nonatomic,copy) NSString *name;

@property (nonatomic, assign) BOOL isLoveCar;

@property (nonatomic, copy) void(^setLoveCarHandle)(NSString *name,NSString *logUrl);

@end
