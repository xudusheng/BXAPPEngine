//
//  BSNL_FMDBSqlTool.h
//  BSNL_Market
//
//  Created by ayi on 2018/5/14.
//  Copyright © 2018 ayi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXDataSqlOrderModel : NSObject

@property (nonatomic,assign) NSComparisonResult order_type;
@property (nonatomic,copy) NSString *order_name;

@end

@interface BXDataSqlUtil : NSObject

#pragma mark - create table sql
+ (NSString *)createTableSqlWithClass:(Class)obj andTableName:(NSString *)tableName andPrimaryKey:(NSString *)key;

#pragma mark - insert sql
+ (NSString *)getInsertDataSql:(NSDictionary *)data inTableName:(NSString *)tableName;
+ (NSArray *)getInsertDataArraySql:(NSArray *)array inTableName:(NSString *)tableName;

#pragma mark - delete sql
+ (NSString *)getDeleteDataSqlInTable:(NSString *)tableName andCondition:(NSDictionary *)condition;

#pragma mark - update sql
+ (NSString *)getUpdateDataSql:(NSDictionary *)data inTableName:(NSString *)tableName conditions:(NSDictionary *)conditions;;

#pragma mark - select sql
+ (NSString *)getSelectTableSqlWithTable:(NSString *)tableName conditions:(NSDictionary *)conditions orderBy:(NSArray<BXDataSqlOrderModel*>*)orderBy limit:(NSRange)range;

#pragma mark - alter sql
+ (NSString *)getAlterSqlWithTable:(NSString *)tableName column:(NSString *)columnName type:(NSString *)type;
@end
