//
//  DBmanager.m
//  BlackDebtBook
//
//  Created by Roman Kovrigin on 30.07.13.
//  Copyright (c) 2013 rkovrigin co. All rights reserved.
//

#import "DBmanager.h"

static DBmanager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBmanager

+(DBmanager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"debtbook.db"]];
    NSLog(@"databasePath %@", databasePath);
    BOOL isSuccess = YES;
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO){
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *debtor_table = "create table if not exists debtor (regno integer primary key, name text)";
            const char *debt_table = "CREATE TABLE if not exists debt (id integer primary key, amount int, debtor int, foreign key (debtor) references debtor(regno))";
            
            if (sqlite3_exec(database, debtor_table, NULL, NULL, &errMsg) != SQLITE_OK){
                isSuccess = NO;
                NSLog(@"Failed to create table debtor");
            }
            
            if (sqlite3_exec(database, debt_table, NULL, NULL, &errMsg) != SQLITE_OK){
                isSuccess = NO;
                NSLog(@"Failed to create table debt");
            }
            
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

- (BOOL) saveData:(NSString*)name
{
    const char *dbpath = [databasePath UTF8String];
    NSLog(@"dbpath%s", dbpath);
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into debtor (name) values (\"%@\")", name];
        NSLog(@"insertSQL %@", insertSQL);
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE){
            return YES;
        } else {
            NSLog(@"sqlite3_step(statement) is %d", sqlite3_step(statement));
            return NO;
        }
        sqlite3_reset(statement);
    }
    return NO;
}

- (NSString*) findByRegisterNumber:(NSString*)registerNumber
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat: @"select name from debtor where regno=\"%@\"",registerNumber];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW){
                NSString *name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                return name;
            }else{
                NSLog(@"Not found");
                return nil;
            }
            sqlite3_reset(statement);
        }
    }
    return nil;
}

-(int)getTableSize:(NSString*)tableName
{
    const char *dbpath = [databasePath UTF8String];
    int size = 0;
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat: @"select count(*) from %@", tableName];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW){
                NSString *name = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
                size = [name intValue];
                return size;
            }else{
                NSLog(@"Not found");
                return 0;
            }
            sqlite3_reset(statement);
        }
    }
    return 0;
}

-(NSMutableArray*) loadDebtors
{
    const char *dbpath = [databasePath UTF8String];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat: @"select * from debtor"];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK){
            while(sqlite3_step(statement) == SQLITE_ROW){
                Debtor *_debtor = [Debtor alloc];
                _debtor.id = [[NSString alloc] initWithUTF8String:
                              (const char *) sqlite3_column_text(statement, 0)];
                _debtor.name = [[NSString alloc] initWithUTF8String:
                                (const char *) sqlite3_column_text(statement, 1)];
                [resultArray addObject:_debtor];
            }
            sqlite3_reset(statement);
        }
    }
    return resultArray;
}

-(NSMutableArray*) loadDebts:(NSString*)debtorID
{
    const char *dbpath = [databasePath UTF8String];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:
                              @"select * from debt where debtor = %@", debtorID];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK){
            while(sqlite3_step(statement) == SQLITE_ROW){
                Debtor *_debtor = [Debtor alloc];
                _debtor.id = [[NSString alloc] initWithUTF8String:
                              (const char *) sqlite3_column_text(statement, 0)];
                _debtor.name = [[NSString alloc] initWithUTF8String:
                                (const char *) sqlite3_column_text(statement, 1)];
                [resultArray addObject:_debtor];
            }
            sqlite3_reset(statement);
        }
    }
    return resultArray;
}

-(NSString*) getStr:(NSString*)query{
    const char *dbpath = [databasePath UTF8String];
    NSString *result = [NSString alloc];
    
    if(sqlite3_open(dbpath, &database) == SQLITE_OK){
        const char *query_stmt = [query UTF8String];
        
        if(sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK){
            while(sqlite3_step(statement) == SQLITE_ROW){
                result = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
            }
            sqlite3_reset(statement);
        }
    }
    return result;
}

-(void) Exec:(NSString*)query{
    const char *dbpath = [databasePath UTF8String];
    
    if(sqlite3_open(dbpath, &database) == SQLITE_OK){
        const char *query_stmt = [query UTF8String];
        if (sqlite3_exec(database, query_stmt, NULL, NULL, NULL) != SQLITE_OK){
            NSLog(@"DELETE DON'T");
        }else{
            NSLog(@"DELETE OK");
        }
        sqlite3_close(database);
    }
}

@end
