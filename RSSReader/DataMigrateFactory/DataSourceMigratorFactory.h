//
//  DataSourceMigratorFactory.h
//  RSSReader
//
//  Created by Dzmitry Noska on 9/20/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSourceMigratorProtocol.h"
#import "FeedItemServiceProtocol.h"
#import "FeedResourceServiceProtocol.h"

@interface DataSourceMigratorFactory : NSObject
- (id<DataSourceMigratorProtocol>) dataSourceMigratorProtocol:(NSNumber*) migratorValue;
- (instancetype) initWithResourceService:(id<FeedResourceServiceProtocol>) resourceService itemService:(id<FeedItemServiceProtocol>) itemService;
@end
