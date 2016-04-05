//
//  EBDBHelper.h
//  MyLimitFree
//
//  Created by Edward on 16/2/18.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EBCarSeriallist;

@interface EBDBHelper : NSObject

+ (instancetype) helper;

- (BOOL) collected:(NSString *) appId;

- (BOOL) addToCollect:(EBCarSeriallist *) model;

- (BOOL) removeFromCollect:(NSString *)appId;

- (NSArray *) getAllCollections;
@end
