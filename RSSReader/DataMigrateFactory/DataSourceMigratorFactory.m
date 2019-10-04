//
//  DataSourceMigratorFactory.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/20/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "DataSourceMigratorFactory.h"
#import "FileToSQLDatasourceMigrator.h"
#import "SQLToFileDataSourceMigrator.h"

@interface DataSourceMigratorFactory ()
@property (strong, nonatomic) NSDictionary<NSNumber*, id<DataSourceMigratorProtocol>>* migratorByID;
@end

@implementation DataSourceMigratorFactory

- (instancetype)init
{
    self = [super init];
    if (self) {
        _migratorByID = @{@(0) : [[SQLToFileDataSourceMigrator alloc] init],
                          @(1) : [[FileToSQLDatasourceMigrator alloc] init]
                        };
    }
    return self;
}

- (id<DataSourceMigratorProtocol>) dataSourceMigratorProtocol:(NSNumber*) migratorValue {
    return [self.migratorByID objectForKey:migratorValue];
}

@end
