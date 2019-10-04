//
//  DataSourceMigratorFactory1.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/4/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "DataSourceMigratorFactory1.h"
#import "FileToSQLDatasourceMigrator.h"
#import "SQLToFileDataSourceMigrator.h"

@interface DataSourceMigratorFactory1()
@property (strong, nonatomic) FileToSQLDatasourceMigrator* fileToSQLDatasourceMigrator;
@property (strong, nonatomic) SQLToFileDataSourceMigrator* sqlToFileDataSourceMigrator;
@end

@implementation DataSourceMigratorFactory1

- (instancetype)initWithStorageValue:(NSNumber *) value
{
    self = [super init];
    if (self) {
        _storageValue = value;
        _fileToSQLDatasourceMigrator = [[FileToSQLDatasourceMigrator alloc] init];
        _sqlToFileDataSourceMigrator = [[SQLToFileDataSourceMigrator alloc] init];
    }
    return self;
}

- (id<DataSourceMigratorProtocol>) dataSourceMigratorProtocol {
    return self.storageValue.intValue == 0 ? self.fileToSQLDatasourceMigrator : self.sqlToFileDataSourceMigrator;
}

- (void)migrateData {
    return [[self dataSourceMigratorProtocol] migrateData];
}

@end
