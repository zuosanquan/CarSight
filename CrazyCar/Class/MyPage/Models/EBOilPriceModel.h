//
//  EBOilPriceModel.h
//  CrazyCar
//
//  Created by Edward on 16/3/9.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EBCheckResult,EBOilList;

@interface EBOilPriceModel : NSObject

@property (nonatomic, assign) NSInteger error_code;

@property (nonatomic, strong) EBCheckResult *result;

@property (nonatomic, copy) NSString *reason;

@end
@interface EBCheckResult : NSObject

@property (nonatomic, copy) NSString *ret_code;

@property (nonatomic, strong) NSArray<EBOilList *> *list;

@end

@interface EBOilList : NSObject

@property (nonatomic, copy) NSString *p0;

@property (nonatomic, copy) NSString *ct;

@property (nonatomic, copy) NSString *p90;

@property (nonatomic, copy) NSString *p93;

@property (nonatomic, copy) NSString *p97;

@property (nonatomic, copy) NSString *prov;

@end

