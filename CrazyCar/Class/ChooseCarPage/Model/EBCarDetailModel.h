//
//  EBCarDetailModel.h
//  CrazyCar
//
//  Created by Edward on 16/2/29.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EBCarSeriallist;

@interface EBCarDetailModel : NSObject

@property (nonatomic, assign) NSInteger brandId;

@property (nonatomic, strong) NSArray<EBCarSeriallist *> *serialList;

@property (nonatomic, assign) BOOL foreign;

@property (nonatomic, copy) NSString *brandName;

@end

@interface EBCarSeriallist : NSObject

@property (nonatomic, assign) NSInteger uv;

@property (nonatomic, copy) NSString *dealerPrice;

@property (nonatomic, assign) NSInteger saleStatus;

@property (nonatomic, copy) NSString *Picture;

@property (nonatomic, assign) NSInteger serialId;

@property (nonatomic, copy) NSString *serialName;

@end

