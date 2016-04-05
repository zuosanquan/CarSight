//
//  EBHotNewModel.h
//  CrazyCar
//
//  Created by Edward on 16/2/29.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBHotNewModel : NSObject<NSMutableCopying>

@property (nonatomic, copy) NSString *itemType;

@property (nonatomic, copy) NSString *lastModify;

@property (nonatomic, assign) NSInteger newsId;

@property (nonatomic, copy) NSString *picCover;

@property (nonatomic, copy) NSString *src;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger viewCount;

@property (nonatomic, assign) NSInteger commentCount;

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, copy) NSString *publishTime;

@property (nonatomic, copy) NSString *dataVersion;

@property (nonatomic, copy) NSString *mediaName;
@end
