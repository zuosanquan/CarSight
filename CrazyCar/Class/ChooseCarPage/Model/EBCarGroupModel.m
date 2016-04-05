//
//  EBCarGroupModel.m
//  CrazyCar
//
//  Created by Edward on 16/3/2.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBCarGroupModel.h"

@implementation EBCarGroupModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"CarList" : [EBCarlistModel class]};
}
@end

@implementation EBCarTypeModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"CarGroup" : [EBCarGroupModel class]};
}

@end

@implementation EBCarlistModel

@end


