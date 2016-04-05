//
//  EBHtmlModel.m
//  CrazyCar
//
//  Created by Edward on 16/3/1.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBHtmlModel.h"

@implementation EBHtmlModel


+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"style" : [EBImageSize class]};
}
@end

@implementation EBImageSize

@end



