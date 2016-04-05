//
//  EBCarDetailModel.m
//  CrazyCar
//
//  Created by Edward on 16/2/29.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBCarDetailModel.h"

@implementation EBCarDetailModel


+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"serialList" : [EBCarSeriallist class]};
}

@end

@implementation EBCarSeriallist

@end


