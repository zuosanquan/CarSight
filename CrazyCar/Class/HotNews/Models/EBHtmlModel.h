//
//  EBHtmlModel.h
//  CrazyCar
//
//  Created by Edward on 16/3/1.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EBImageSize;

@interface EBHtmlModel : NSObject

@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) NSArray<EBImageSize *> *style;

@property (nonatomic, assign) NSInteger type;

@end

@interface EBImageSize : NSObject

@property (nonatomic, assign) NSInteger width;

@property (nonatomic, assign) NSInteger height;

@end

