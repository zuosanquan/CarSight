//
//  EBCarModel.h
//  CrazyCar
//
//  Created by Edward on 16/2/29.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBCarModel : NSObject

@property (nonatomic, copy) NSString *logoUrl;

@property (nonatomic, assign) NSInteger uv;

@property (nonatomic, assign) NSInteger masterId;

@property (nonatomic, assign) NSInteger saleStatus;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *initial;

@end
