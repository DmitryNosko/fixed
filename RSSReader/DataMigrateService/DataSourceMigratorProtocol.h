//
//  DataSourceMigratorProtocol.h
//  RSSReader
//
//  Created by Dzmitry Noska on 9/20/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataSourceMigratorProtocol <NSObject>
- (void) migrateData;
@end

