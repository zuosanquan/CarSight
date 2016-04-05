//
//  EBCarGroupModel.h
//  CrazyCar
//
//  Created by Edward on 16/3/2.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EBCarlistModel;

@interface EBCarGroupModel : NSObject

@property (nonatomic, strong) NSArray<EBCarlistModel *> *CarList;

@property (nonatomic, copy) NSString *Name;

@end

@interface EBCarTypeModel : NSObject

@property (nonatomic, strong) NSArray<EBCarGroupModel *> *CarGroup;

@property (nonatomic, copy) NSString *Name;

@end

@interface EBCarlistModel : NSObject

@property (nonatomic, copy) NSString *MinPrice;

@property (nonatomic, copy) NSString *CarImg;

@property (nonatomic, copy) NSString *Name;

@property (nonatomic, copy) NSString *CarLink;

@property (nonatomic, copy) NSString *MallPrice;

@property (nonatomic, assign) BOOL IsSupport;

@property (nonatomic, copy) NSString *SaleState;

@property (nonatomic, copy) NSString *ImportType;

@property (nonatomic, copy) NSString *Trans;

@property (nonatomic, copy) NSString *CarId;

@property (nonatomic, assign) NSInteger SupportType;

@property (nonatomic, copy) NSString *ReferPrice;

@property (nonatomic, copy) NSString *Year;

@end

