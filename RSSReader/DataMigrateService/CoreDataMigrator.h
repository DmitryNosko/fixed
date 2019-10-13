//
//  CoreDataMigrator.h
//  RSSReader
//
//  Created by USER on 10/13/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSourceMigratorProtocol.h"
#import "FeedResourceServiceProtocol.h"
#import "FeedItemServiceProtocol.h"

@interface CoreDataMigrator : NSObject <DataSourceMigratorProtocol>
- (instancetype)initWithResource:(id<FeedResourceServiceProtocol>) resourceService andItemService:(id<FeedItemServiceProtocol>) itemService;
@end
