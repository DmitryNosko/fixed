//
//  FileToSQLDatasourceMigrator.h
//  RSSReader
//
//  Created by Dzmitry Noska on 9/20/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSourceMigratorProtocol.h"
#import "FeedResourceServiceProtocol.h"
#import "FeedItemServiceProtocol.h"

@interface SQLDatasourceMigrator : NSObject <DataSourceMigratorProtocol>
- (instancetype)initWithResource:(id<FeedResourceServiceProtocol>) resourceService andItemService:(id<FeedItemServiceProtocol>) itemService;
@end
