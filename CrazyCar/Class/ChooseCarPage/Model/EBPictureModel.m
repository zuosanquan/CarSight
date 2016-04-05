//
//  EBPictureModel.m
//  CrazyCar
//
//  Created by Edward on 16/3/9.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBPictureModel.h"

@implementation EBPictureModel

@end

@implementation EBRequestStatusModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"list" : [EBPictureGroup class]};
}

@end


@implementation EBPictureGroup

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"Images" : [EBImagesModel class]};
}

@end


@implementation EBImagesModel

@end


