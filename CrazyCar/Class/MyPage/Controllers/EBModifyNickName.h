//
//  EBModifyNickName.h
//  CrazyCar
//
//  Created by Edward on 16/3/7.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EBModifyNickName;

@protocol EBModifyNickNameDelegate <NSObject>

- (void)modifyNickNameSuccess:(EBModifyNickName *)modify andNickName:(NSString *)nickName;

@end

@interface EBModifyNickName : UIViewController

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, weak) id<EBModifyNickNameDelegate> modifyDelegate;

@end
