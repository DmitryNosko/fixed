//
//  FeedItemRepository.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/13/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "SQLFeedItemRepository.h"
#import "NSString+NSStringDateCategory.h"
#import "NSUUID+NSUUIDCategory.h"
#import "SQLFeedItemRepositoryConstants.h"

@implementation SQLFeedItemRepository

#pragma mark - FeedItem Requests

- (FeedItem *) addFeedItem:(FeedItem *) item {
    NSString *insertFeedItem = [NSString stringWithFormat:INSERT_FEEDITEM,
                                [item.identifier UUIDString],
                                item.itemTitle,
                                item.link,
                                item.pubDate,
                                item.itemDescription,
                                item.enclosure,
                                item.imageURL,
                                @(item.isFavorite),
                                @(item.isReadingInProgress),
                                @(item.isReadingComplite),
                                @(item.isAvailable),
                                item.resourceURL,
                                [item.resource.identifier UUIDString]
                                ];
    [self sqlRequestWithDBPath:[self dataBasePath] db:rssDataBase request:[insertFeedItem UTF8String]];
    return item;
}

- (void) updateFeedItem:(FeedItem *) item {
    NSString *updateFeedItem = [NSString stringWithFormat:UPDATE_FEEDITEM, @(item.isFavorite), @(item.isReadingInProgress), @(item.isReadingComplite), @(item.isAvailable), [item.identifier UUIDString]];
    [self sqlRequestWithDBPath:[self dataBasePath] db:rssDataBase request:[updateFeedItem UTF8String]];
}

- (NSMutableArray<FeedItem *>*) feedItemsForResource:(NSUUID *) identifier {
    sqlite3_stmt *statement;
    NSMutableArray<FeedItem *>* items = [NSMutableArray array];
    
    if (sqlite3_open([self dataBasePath], &rssDataBase) == SQLITE_OK) {
        
        const char *selectFeedItemsStatement = [[NSString stringWithFormat:SELECT_FEEDITEM_BY_ID, [identifier UUIDString]] UTF8String];
        
        if (sqlite3_prepare_v2(rssDataBase, selectFeedItemsStatement, -1, &statement, NULL) == SQLITE_OK) {
            NSLog(@"Statement was prepared for SELECT_FEEDITEM_BY_ID %@", @(selectFeedItemsStatement));
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
                
                NSUUID* resourceID = [[NSUUID alloc] initWithUUIDString:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)]];
                NSString *resourceName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 13)];
                NSURL *resURL = [NSURL URLWithString:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 14)]];
                
                FeedResource* resource = [[FeedResource alloc] initWithID:resourceID name:resourceName url:resURL];
                
                FeedItem* item = [[[[[[[[[[[[[[[[FeedItemBuilderService alloc] init]
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
                [items addObject:item];
            }
        } else {
            NSLog(@"Statement was not prepared for SELECT_FEEDITEM_BY_ID %@", @(selectFeedItemsStatement));
        }
        sqlite3_finalize(statement);
        sqlite3_close(rssDataBase);
    }
    
    return items;
}

- (NSMutableArray<FeedItem *>*) feedItemsForResources:(NSMutableArray<NSUUID *>*) resourcesIDs {
    const char *selectFeedItemsStatement = [[NSString stringWithFormat:SELECT_NON_COMPLITED_FEEDITEMS_BY_IDS, [self prepareQueryParameters:[NSUUID toString:resourcesIDs]]] UTF8String];
    return [self feedItemsFromResource:resourcesIDs withDBPath:[self dataBasePath] db:rssDataBase request:selectFeedItemsStatement];
}

- (NSMutableArray<FeedItem *> *) allFeedItemsForResources:(NSMutableArray<NSUUID *> *)resourcesIDs {
    const char *selectFeedItemsStatement = [[NSString stringWithFormat:SELECT_ALL_FEEDITEMS_BY_IDS, [self prepareQueryParameters:[NSUUID toString:resourcesIDs]]] UTF8String];
    return [self feedItemsFromResource:resourcesIDs withDBPath:[self dataBasePath] db:rssDataBase request:selectFeedItemsStatement];
}

- (void) removeFeedItem:(FeedItem *) item {
    const char *deleteStatement = [[NSString stringWithFormat:DELETE_FEEDITEM, [item.identifier UUIDString]] UTF8String];
    [self sqlRequestWithDBPath:[self dataBasePath] db:rssDataBase request:deleteStatement];
}

- (void) removeFeedItemForResource:(NSUUID *) identifier {
    const char *deleteFeedItemByResourceIDStatement = [[NSString stringWithFormat:DELETE_FEEDITEM_BY_RESOURCE_ID, [identifier UUIDString]] UTF8String];
    [self sqlRequestWithDBPath:[self dataBasePath] db:rssDataBase request:deleteFeedItemByResourceIDStatement];
}

- (void) removeAllFeedItems {
    [self sqlRequestWithDBPath:[self dataBasePath] db:rssDataBase request:DELETE_ALL_FEEDITEMS];
}

- (NSMutableArray<FeedItem *>*) favoriteFeedItems:(NSMutableArray<NSUUID *>*) resourcesIDs {
    const char *selectFavoriteItemsStatement = [[NSString stringWithFormat:SELECT_FAVORITE_FEEDITEM, [self prepareQueryParameters:[NSUUID toString:resourcesIDs]]] UTF8String];
    return [self feedItemsFromResource:resourcesIDs withDBPath:[self dataBasePath] db:rssDataBase request:selectFavoriteItemsStatement];
}

- (NSMutableArray<NSString *>*) favoriteFeedItemLinks:(NSMutableArray<NSUUID *>*) resourcesIDs {
    const char *selectFavoriteItemLinksStatement = [[NSString stringWithFormat:SELECT_FAVORITE_FEEDITEM_URL, [self prepareQueryParameters:[NSUUID toString:resourcesIDs]]] UTF8String];
    return [self feedItemsLinks:resourcesIDs withDBPath:[self dataBasePath] db:rssDataBase request:selectFavoriteItemLinksStatement];
}

- (NSMutableArray<NSString *>*) readingInProgressFeedItemLinks:(NSMutableArray<NSUUID *>*) resourcesIDs {
    const char *selectReadingInProgressFeedItemLinksStatement = [[NSString stringWithFormat:SELECT_READING_IN_PROGRESS_FEEDITEM_URL, [self prepareQueryParameters:[NSUUID toString:resourcesIDs]]] UTF8String];
    return [self feedItemsLinks:resourcesIDs withDBPath:[self dataBasePath] db:rssDataBase request:selectReadingInProgressFeedItemLinksStatement];
}

- (NSMutableArray<NSString *>*) readingCompliteFeedItemLinks:(NSMutableArray<NSUUID *>*) resourcesIDs {
    const char *selectReadingCompliteFeedItemLinksStatement = [[NSString stringWithFormat:SELECT_READING_COMPLITE_FEEDITEM_URL, [self prepareQueryParameters:[NSUUID toString:resourcesIDs]]] UTF8String];
    return [self feedItemsLinks:resourcesIDs withDBPath:[self dataBasePath] db:rssDataBase request:selectReadingCompliteFeedItemLinksStatement];
}

@end
