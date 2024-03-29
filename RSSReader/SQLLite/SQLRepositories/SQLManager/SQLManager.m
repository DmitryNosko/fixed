//
//  AbstractSQLRepository.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/4/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "SQLManager.h"
#import "NSFileManager+NSFileManagerCategory.h"
#import "NSString+NSStringDateCategory.h"
#import "SQLManagerConstants.h"

@implementation SQLManager

- (void) createDB {
    NSLog(@"DBPath = %@", @([self dataBasePath]));
    if (![self isDBCreated]) {
        
        if (sqlite3_open([self dataBasePath], &rssDataBase) == SQLITE_OK) {
            char *errMsg = nil;
            [self createTable:SQL_CREATE_FEEDRESOURCE errMsg:errMsg];
            [self createTable:SQL_CREATE_FEEDITEM errMsg:errMsg];
            sqlite3_close(rssDataBase);
        } else {
            NSLog(@"Failed to open/create database at path %@", @([self dataBasePath]));
        }
    }
}

- (const char *) dataBasePath {
    return [[NSFileManager pathForFile:SQL_DATA_BASE_NAME] UTF8String];
}

- (BOOL) isDBCreated {
    return [[[NSFileManager alloc] init] fileExistsAtPath:@([self dataBasePath])];
}

- (void) createTable:(const char*) createSQL errMsg:(char *) errorMsg {
    if (sqlite3_exec(rssDataBase, createSQL, NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"Successful created = %@", @(createSQL));
    } else {
        NSLog(@"Failed to create = %@", @(createSQL));
    }
}

- (void) sqlRequestWithDBPath:(const char*) dbPath db:(sqlite3*) dataBase request:(const char*) request { //TODO rename method
    sqlite3_stmt *statement;
    const char *dataBasePath = dbPath;
    
    if (sqlite3_open(dataBasePath, &dataBase) == SQLITE_OK) {
        sqlite3_prepare_v2(dataBase, request, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"Successec to make request %@", @(request));
        } else {
            NSLog(@"Failed to make request %@", @(request));
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
}

- (NSMutableArray<NSString *>*) feedItemsLinks:(NSMutableArray<NSUUID *>*) resourcesIDs withDBPath:(const char*) dbPath db:(sqlite3*) dataBase request:(const char*) request {
    sqlite3_stmt *statement;
    NSMutableArray<NSString *>* links = [NSMutableArray array];
    
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK) {
        
        if (sqlite3_prepare_v2(dataBase, request, -1, &statement, NULL) == SQLITE_OK) {
            
            NSLog(@"Successful request %@", @(request));
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString* link = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                [links addObject:link];
            }
        } else {
            NSLog(@"Unsuccessful request %@", @(request));
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    
    return links;
}

- (NSMutableArray<FeedItem *>*) feedItemsFromResource:(NSMutableArray<NSUUID *>*) resourcesIDs withDBPath:(const char*) dbPath db:(sqlite3*) dataBase request:(const char*) request {
    sqlite3_stmt *statement;
    NSMutableArray<FeedItem *>* items = [NSMutableArray array];
    
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK) {
        if (sqlite3_prepare_v2(dataBase, request, -1, &statement, NULL) == SQLITE_OK) {
            NSLog(@"Success to make request %@", @(request));
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSUUID* itemID = [[NSUUID alloc] initWithUUIDString:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
                NSString *itemTitle = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSMutableString* link = [[NSMutableString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                NSDate *pubDate = [[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)] toDate];
                NSMutableString *itemDescription = [[NSMutableString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                NSString *enclousure = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                NSString *imageURL = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                BOOL isFavorite = [[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)] boolValue];
                BOOL isReadingInProgress = [[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)] boolValue];
                BOOL isReadingComplite = [[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)] boolValue];
                BOOL isAvailable = [[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)] boolValue];
                NSURL *resourceURL = [NSURL URLWithString:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)]];
                
                const char *tmp = (const char *) sqlite3_column_text(statement, 12);
                NSUUID* resourceID = nil;
                FeedItem* item = nil;
                if (tmp) {
                     resourceID = [[NSUUID alloc] initWithUUIDString:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)]];
                    NSString *resourceName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 13)];
                    NSURL *resURL = [NSURL URLWithString:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 14)]];
                    
                    FeedResource* resource = [[FeedResource alloc] initWithID:resourceID name:resourceName url:resURL];
                    item = [[[[[[[[[[[[[[[[FeedItemBuilderService alloc] init]
                                                   buildIdentifier:itemID]
                                                  buildItemTitle:itemTitle]
                                                 buildLink:link]
                                                buildPubDate:pubDate]
                                               buildItemDescription:itemDescription]
                                              buildEnclosure:enclousure]
                                             buildImageURL:imageURL]
                                            buildIsFavorite:isFavorite]
                                           buildIsReadingInProgress:isReadingInProgress]
                                          buildIsReadingComplite:isReadingComplite]
                                         buildIsAvailable:isAvailable]
                                        buildResourceURL:resourceURL]
                                       buildResource:resource]
                                      buildFeedItem];
                } else {
                    item = [[[[[[[[[[[[[[[[FeedItemBuilderService alloc] init]
                                                   buildIdentifier:itemID]
                                                  buildItemTitle:itemTitle]
                                                 buildLink:link]
                                                buildPubDate:pubDate]
                                               buildItemDescription:itemDescription]
                                              buildEnclosure:enclousure]
                                             buildImageURL:imageURL]
                                            buildIsFavorite:isFavorite]
                                           buildIsReadingInProgress:isReadingInProgress]
                                          buildIsReadingComplite:isReadingComplite]
                                         buildIsAvailable:isAvailable]
                                        buildResourceURL:resourceURL]
                                       buildResource:nil]
                                      buildFeedItem];
                }
                [items addObject:item];
            }
        } else {
            NSLog(@"Unsuccesss to make request %@", @(request));
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    
    return items;
}

- (NSString *) prepareQueryParameters:(NSArray<id>*) parameters {
    NSMutableArray<NSString *>* params = [NSMutableArray new];
    for (id obj in parameters) {
        [params addObject:[NSString stringWithFormat:@"\"%@\"", obj]];
    }
    return [params componentsJoinedByString:@","];
}

- (NSMutableArray<FeedResource *> *) resourcesFromRequest:(const char *) request {
    sqlite3_stmt *statement;
    FeedResource* resource = nil;
    
    NSMutableArray<FeedResource *>* resources = [NSMutableArray array];
    
    if (sqlite3_open([self dataBasePath], &rssDataBase) == SQLITE_OK) {
        
        if (sqlite3_prepare_v2(rssDataBase, request, -1, &statement, NULL) == SQLITE_OK) {
            
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

@end
