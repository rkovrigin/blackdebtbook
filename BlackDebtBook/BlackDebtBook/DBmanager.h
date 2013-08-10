//
//  DBmanager.h
//  BlackDebtBook
//
//  Created by Roman Kovrigin on 30.07.13.
//  Copyright (c) 2013 rkovrigin co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Debtor.h"

@interface DBmanager : NSObject{
    NSString *databasePath;
}

+(DBmanager*)getSharedInstance;
-(BOOL)createDB;
-(BOOL)saveData:(NSString*)name;
-(NSString*) findByRegisterNumber:(NSString*)registerNumber;
-(NSMutableArray*) loadDebtors;
-(NSMutableArray*) loadDebts:(NSString*)debtorID;
-(int)getTableSize:(NSString*)tableName;
-(NSString*)getStr:(NSString*)query;

@end
