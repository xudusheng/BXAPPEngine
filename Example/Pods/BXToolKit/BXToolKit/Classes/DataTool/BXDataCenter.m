//
//  BSNL_FMDBTool.m
//  BSNL_Market
//
//  Created by ayi on 2018/5/14.
//  Copyright © 2018 ayi. All rights reserved.
//

#import "BXDataCenter.h"
#import "FMDB.h"
#import "UIApplication+BXAddition.h"
#import "BXDataSqlUtil.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface BXDataCenter()
{
    FMDatabaseQueue *dbQueue;
}
@property (strong, nonatomic) NSString *dbPath;

@end

static BXDataCenter *instance = nil;
static NSString *kBXDataCenterDataBaseName = @"BISINUOLAN";

@implementation BXDataCenter

+ (void)setDataBaseName:(NSString *)dataBaseName {
    kBXDataCenterDataBaseName = dataBaseName;
}

#pragma mark - 单例
+(instancetype)shareCenter {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}


- (instancetype)init{
    self = [super init];
    if(self){
        NSString *directory = [[UIApplication sharedApplication].documentsPath stringByAppendingPathComponent:@"database"];
        NSFileManager* fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:directory]) {
            [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *dataBaseName = @"";
        if ([kBXDataCenterDataBaseName hasSuffix:@".sqlite"]) {
            dataBaseName = kBXDataCenterDataBaseName;
        }else {
            dataBaseName = [kBXDataCenterDataBaseName stringByAppendingString:@".sqlite"];
        }
        NSString *path = [directory stringByAppendingPathComponent:dataBaseName];
        dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    }
    return self;
}

#pragma mark - create table
- (BOOL)createTableWithClass:(Class)obj andTableName:(NSString *)tableName andPrimaryKey:(NSString *)key{
    NSString *sql = [BXDataSqlUtil createTableSqlWithClass:obj andTableName:tableName andPrimaryKey:key];
    return [self createTableWithSql:sql andTableName:tableName];
}

- (BOOL)createTableWithSql:(NSString *)sql andTableName:(NSString *)tableName {
    __block BOOL  excute_result = false;
    [dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            excute_result = [db executeUpdate:sql];
        }
    }];
    return excute_result;
}
#pragma mark - clear
// 删除表
- (BOOL)deleteTable:(NSString *)tableName {
    __block BOOL  excute_result = false;
    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    [dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            excute_result = [db executeUpdate:sqlstr];
        }
    }];
    return excute_result;
}
// 清空表
- (BOOL)deleteAllDataFromTable:(NSString *)tableName {
    __block BOOL  excute_result = false;
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    [dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            excute_result = [db executeUpdate:sqlstr];
        }
    }];
    return excute_result;
}
#pragma mark - insert
- (BOOL)insertData:(id)obj inTableName:(NSString *)tableName{
    __block BOOL  excute_result = false;
    NSString *sql = [BXDataSqlUtil getInsertDataSql:obj inTableName:tableName];
    [dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            NSLog(@"插入成功");
            excute_result = [db executeUpdate:sql];
        } else {
            NSLog(@"插入失败");
        }
    }];
    NSLog(@"是不是线程阻塞");
    return excute_result;
}
- (BOOL)insertDataArray:(NSArray *)array inTableName:(NSString *)tableName{
    __block BOOL  excute_result = false;
    NSArray *sqlArray = [BXDataSqlUtil getInsertDataArraySql:array inTableName:tableName];
    for (NSString *sql in sqlArray) {
        [dbQueue inDatabase:^(FMDatabase *db) {
            excute_result = [db executeUpdate:sql];
            if (excute_result == NO) {
                NSLog(@"数据插入失败");
            }
        }];
    }
    return excute_result;
}
#pragma mark - delete
- (BOOL)deleteDataWithTableName:(NSString *)tableName conditions:(NSDictionary *)conditions {
    __block BOOL  excute_result = NO;
NSString *sql = [BXDataSqlUtil getDeleteDataSqlInTable:tableName andCondition:conditions];
    [dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            excute_result = [db executeUpdate:sql];
        }
    }];
    return excute_result;
}
#pragma mark - inquire
- (NSArray *)selectDataWithTableName:(NSString *)tableName conditions:(NSDictionary *)conditions {
    return [self selectDataWithTableName:tableName conditions:conditions orderBy:nil];
}
- (NSArray *)selectDataWithTableName:(NSString *)tableName conditions:(NSDictionary *)conditions orderBy:(NSArray *)orderBy {
    return [self selectDataWithTableName:tableName conditions:conditions orderBy:orderBy limit:NSMakeRange(0, 0)];
}
- (NSArray *)selectDataWithTableName:(NSString *)tableName conditions:(NSDictionary *)conditions orderBy:(NSArray *)orderBy limit:(NSRange)range {
    NSString *sql = [BXDataSqlUtil getSelectTableSqlWithTable:tableName conditions:conditions orderBy:orderBy limit:range];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            [array addObject:[rs resultDictionary]];
        }
        [rs close];
        
    }];
    return array;
}

#pragma mark - update
- (BOOL)updateData:(id)obj inTableName:(NSString *)tableName conditions:(NSDictionary *)conditions{
    __block BOOL  excute_result = NO;
    NSString *sql = [BXDataSqlUtil getUpdateDataSql:obj inTableName:tableName conditions:conditions];
    [dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            excute_result = [db executeUpdate:sql];
        }
    }];
    return excute_result;
}

#pragma mark - search
- (NSArray *)searchDataWithTableName:(NSString *)tableName conditionSql:(NSString *)conditionSql {
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:conditionSql];
        while ([rs next])
        {
            [array addObject:[rs resultDictionary]];
        }
        [rs close];
        
    }];
    return array;
}
@end
