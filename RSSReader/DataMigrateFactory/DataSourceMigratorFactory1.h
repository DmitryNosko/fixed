//
//  DataSourceMigratorFactory1.h
//  RSSReader
//
//  Created by Dzmitry Noska on 10/4/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSourceMigratorProtocol.h"

@interface DataSourceMigratorFactory1 : NSObject <DataSourceMigratorProtocol>
@property (strong, nonatomic) NSNumber* storageValue;
- (id<DataSourceMigratorProtocol>) dataSourceMigratorProtocol;
- (instancetype)initWithStorageValue:(NSNumber *) value;
@end
