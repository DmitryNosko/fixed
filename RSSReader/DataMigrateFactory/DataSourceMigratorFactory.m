//
//  DataSourceMigratorFactory.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/20/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "DataSourceMigratorFactory.h"
#import "SQLDatasourceMigrator.h"
#import "FileDataSourceMigrator.h"
#import "CoreDataMigrator.h"

@interface DataSourceMigratorFactory ()
@property (strong, nonatomic) NSDictionary<NSNumber*, id<DataSourceMigratorProtocol>>* migratorByID;
@end

@implementation DataSourceMigratorFactory

- (instancetype) initWithResourceService:(id<FeedResourceServiceProtocol>) resourceService itemService:(id<FeedItemServiceProtocol>) itemService
{
    self = [super init];
    if (self) {
        _migratorByID = @{@(0) : [[FileDataSourceMigrator alloc] initWithResource:resourceService andItemService:itemService],
                          @(1) : [[SQLDatasourceMigrator alloc] initWithResource:resourceService andItemService:itemService],
                          @(2) : [[CoreDataMigrator alloc] initWithResource:resourceService andItemService:itemService]
                        };
    }
    return self;
}

- (id<DataSourceMigratorProtocol>) dataSourceMigratorProtocol:(NSNumber*) migratorValue {
    return [self.migratorByID objectForKey:migratorValue];
}

@end
