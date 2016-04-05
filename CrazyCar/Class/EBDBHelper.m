//
//  EBDBHelper.m
//  MyLimitFree
//
//  Created by Edward on 16/2/18.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBDBHelper.h"
#import "EBCarDetailModel.h"
@implementation EBDBHelper{
    FMDatabase *_db;
}

- (instancetype)init{
    @throw [NSException exceptionWithName:@"error" reason:@"单例不能用init方法" userInfo:nil];
}

- (instancetype) initPravite{
    if (self = [super init]) {
//        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];//直接拿到Documents
        NSString *dbFilePath = [NSString stringWithFormat:@"%@/Documents/CrazyCar.db",NSHomeDirectory()];
        _db = [FMDatabase databaseWithPath:dbFilePath];
        if (_db && [_db open]) {
            NSString *sql =
            @"create table if not exists TbCollect("
            "serialId text(100) primary key,"
            "Picture text(1500) not null,"
            "serialName text(50) not null"
            ")";
            if ([_db executeUpdate:sql]) {
                [_db close];
            }else{
                NSLog(@"创建数据库失败");
            }
        }else{
            NSLog(@"打开数据库失败");
        }
    }
    return self;
}
+ (instancetype)helper{
    static EBDBHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (self) {
            if (!helper) {
                helper = [[EBDBHelper alloc] initPravite];
            }
        }
    });
    return helper;
}

- (BOOL)collected:(NSString *)appId{
    BOOL isCollect = NO;
    if (_db &&[_db open]) {
        NSString *sql = @"select * from TbCollect where serialId=?";
        FMResultSet *result = [_db executeQuery:sql,appId];
        isCollect = [result next];
        [_db close];
    }
    return isCollect;
}

- (BOOL)addToCollect:(EBCarSeriallist *)model{
//    NSLog(@"%ld",model.serialId);
//    NSLog(@"%@",model.Picture);
//    NSLog(@"%@",model.serialName);
    if (!model.serialId) {
        return NO;
    }
    BOOL isSuccuss = NO;
    if (_db && [_db open]) {
        NSString *sql = @"insert into TbCollect values (?,?,?)";
        NSString *id = [NSString stringWithFormat:@"%ld",model.serialId];
        isSuccuss = [_db executeUpdate:sql,id,model.Picture,model.serialName];
        [_db close];
    }
    return isSuccuss;
}

- (BOOL)removeFromCollect:(NSString *)appId{
    BOOL isSuccuss = NO;
    if (_db && [_db open]) {
        NSString *sql = @"delete from TbCollect where serialId=?";
        isSuccuss = [_db executeUpdate:sql,appId];
        [_db close];
    }
    return isSuccuss;
}

- (NSArray *)getAllCollections{
    NSMutableArray *allCollections = [NSMutableArray array];
    if (_db && [_db open]) {
        NSString *sql = @"select * from TbCollect";
        FMResultSet *result = [_db executeQuery:sql];
        while ([result next]) {
            EBCarSeriallist *model = [[EBCarSeriallist alloc] init];
            model.serialId = [[result stringForColumn:@"serialId"] integerValue];
            model.Picture = [result stringForColumn:@"Picture"];
            model.serialName = [result stringForColumn:@"serialName"];
            [allCollections addObject:model];
        }
        [_db close];
    }
    return [allCollections copy];
}
@end
