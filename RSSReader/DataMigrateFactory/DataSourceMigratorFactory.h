//
//  DataSourceMigratorFactory.h
//  RSSReader
//
//  Created by Dzmitry Noska on 9/20/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSourceMigratorProtocol.h"

@interface DataSourceMigratorFactory : NSObject
- (id<DataSourceMigratorProtocol>) dataSourceMigratorProtocol:(NSNumber*) migratorValue;
@end