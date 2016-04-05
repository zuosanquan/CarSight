//
//  EBSelfInfoController.h
//  CrazyCar
//
//  Created by Edward on 16/3/7.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EBSelfInfoControllerDelegate <NSObject>

- (void) setImage:(UIImage *)image andNickName:(NSString *)nickName andCarIconUrl:(NSString *)logUrl;

@end

@interface EBSelfInfoController : UIViewController

@property (nonatomic, weak)  id<EBSelfInfoControllerDelegate> delegate;

@end
