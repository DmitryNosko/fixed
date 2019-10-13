//
//  FeedResourceRepository.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/13/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "SQLFeedResourceRepository.h"
#import "SQLFeedResourceRepositoryConstants.h"

@implementation SQLFeedResourceRepository

#pragma mark - FeedResource Requests

- (FeedResource *) addFeedResource:(FeedResource *) resource {
    const char *insertStatement = [[NSString stringWithFormat:INSERT_FEEDRESOURCE_SQL, [resource.identifier UUIDString], resource.name, [resource.url absoluteString]] UTF8String];
    [self sqlRequestWithDBPath:[self dataBasePath] db:rssDataBase request:insertStatement];
    return resource;
}

- (void) removeFeedResource:(NSUUID *) resourceID {
    const char *removeStatement = [[NSString stringWithFormat:DELETE_FEEDRESOURCE_SQL, [resourceID UUIDString]] UTF8String];
    [self sqlRequestWithDBPath:[self dataBasePath] db:rssDataBase request:removeStatement];
}

- (NSMutableArray<FeedResource *>*) feedResources {
    
    sqlite3_stmt *statement;
    const char *dbpath = [self dataBasePath];
    FeedResource* resource = nil;
    
    NSMutableArray<FeedResource *>* resources = [NSMutableArray array];
    
    if (sqlite3_open(dbpath, &rssDataBase) == SQLITE_OK) {
        
        if (sqlite3_prepare_v2(rssDataBase, SELECT_FEEDRESOURCE_SQL, -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSUUID* identifier = [[NSUUID alloc] initWithUUIDString:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
                NSString *name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSURL* url = [NSURL URLWithString:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)]];
                
                resource = [[FeedResource alloc] initWithID:identifier name:name url:url];
                [resources addObject:resource];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(rssDataBase);
    }
    
    return resources;
}

- (FeedResource *) resourceByURL:(NSURL *) url {
    sqlite3_stmt *statement;
    const char *dataBasePath = [self dataBasePath];
    
    FeedResource* resource = nil;
    
    if (sqlite3_open(dataBasePath, &rssDataBase) == SQLITE_OK) {
        
        const char *selectFeedResourceStatement = [[NSString stringWithFormat:SELECT_FEEDRESOURSE_BY_URL, url.absoluteString] UTF8String];
        
        if (sqlite3_prepare_v2(rssDataBase, selectFeedResourceStatement, -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSUUID* identifier = [[NSUUID alloc] initWithUUIDString:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
                NSString *name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSURL* url = [NSURL URLWithString:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)]];
                
                resource = [[FeedResource alloc] initWithID:identifier name:name url:url];
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(rssDataBase);
    }
    
    return resource;
}

@end
