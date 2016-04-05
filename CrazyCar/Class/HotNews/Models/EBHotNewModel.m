//
//  EBHotNewModel.m
//  CrazyCar
//
//  Created by Edward on 16/2/29.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBHotNewModel.h"

@implementation EBHotNewModel

- (id)mutableCopyWithZone:(NSZone *)zone{
    EBHotNewModel *model = [[self class] allocWithZone:zone];
    model.itemType = [_itemType copy];
    model.lastModify = [_lastModify copy];
    model.newsId = _newsId;
    model.picCover = [_picCover copy];
    model.src = [_src copy];
    model.type = _type;
    model.title = [_title copy];
    model.viewCount = _viewCount;
    model.commentCount = _commentCount;
    model.filePath = [_filePath copy];
    model.publishTime = [_publishTime copy];
    model.dataVersion = [_dataVersion copy];
    
    return model;
}

@end
