//
//  AbstractSQLRepository.h
//  RSSReader
//
//  Created by Dzmitry Noska on 10/4/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedItem.h"
#import "FeedResource.h"
#import <sqlite3.h>

@interface SQLManager : NSObject {
    sqlite3* rssDataBase;
}

- (void) createDB;
- (const char*) dataBasePath;
- (void) sqlRequestWithDBPath:(const char*) dbPath db:(sqlite3*) dataBase request:(const char*) request;
- (NSMutableArray<NSString *>*) feedItemsLinks:(NSMutableArray<NSUUID *>*) resourcesIDs withDBPath:(const char*) dbPath db:(sqlite3*) dataBase request:(const char*) request;
- (NSMutableArray<FeedItem *>*) feedItemsFromResource:(NSMutableArray<NSUUID *>*) resourcesIDs withDBPath:(const char*) dbPath db:(sqlite3*) dataBase request:(const char*) request;
- (NSString *) prepareQueryParameters:(NSArray<id>*) parameters;
@end
