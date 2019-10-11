//
//  DataSourceMigratorProtocol1.h
//  RSSReader
//
//  Created by Dzmitry Noska on 10/11/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedItem.h"
#import "FeedResource.h"

@protocol DataSourceMigratorProtocol1 <NSObject>
- (NSMutableArray<FeedResource *>*) loadFeedResources;
- (void) save:(NSMutableArray<FeedResource *>*) resources;
@end
