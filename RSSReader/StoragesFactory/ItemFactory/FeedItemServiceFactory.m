//
//  FeedItemServiceFactory1.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/4/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "FeedItemServiceFactory.h"
#import "FileFeedItemService.h"
#import "SQLFeedItemService.h"
#import "CoreDataFeedItemService.h"
#import "FeedFactoriesConstants.h"

@interface FeedItemServiceFactory()
@property (strong, nonatomic) FileFeedItemService* fileFeedItemService;
@property (strong, nonatomic) SQLFeedItemService* sqlFeedItemService;
@property (strong, nonatomic) CoreDataFeedItemService* cdFeedItemService;
@end

@implementation FeedItemServiceFactory

- (instancetype)initWithStorageValue:(NSNumber *) value
{
    self = [super init];
    if (self) {
        _storageValue = value;
        _fileFeedItemService = [[FileFeedItemService alloc] init];
        _sqlFeedItemService = [[SQLFeedItemService alloc] init];
        _cdFeedItemService = [[CoreDataFeedItemService alloc] init];
    }
    return self;
}

- (id<FeedItemServiceProtocol>) feedItemServiceProtocol {
    if (self.storageValue.intValue == FILE_STORAGE_VALUE) {
        return self.fileFeedItemService;
    } else if (self.storageValue.intValue == SQL_STORAGE_VALUE) {
        return self.sqlFeedItemService;
    } else {
        return self.cdFeedItemService;
    }
}

- (NSMutableArray<FeedItem *> *) allFeedItemsForResources:(NSMutableArray<FeedResource *> *)resources {
    return [[self feedItemServiceProtocol] allFeedItemsForResources:resources];
}

- (NSMutableArray<FeedItem *> *) cleanSaveFeedItems:(NSMutableArray<FeedItem *> *)items {
    return [[self feedItemServiceProtocol] cleanSaveFeedItems:items];
}

- (NSMutableArray<NSString *> *) favoriteFeedItemLinks:(NSMutableArray<FeedResource *> *)resources {
    return [[self feedItemServiceProtocol] favoriteFeedItemLinks:resources];
}

- (NSMutableArray<FeedItem *> *) favoriteFeedItems:(NSMutableArray<FeedResource *> *)resources {
    return [[self feedItemServiceProtocol] favoriteFeedItems:resources];
}

- (NSMutableArray<FeedItem *> *) feedItemsForResources:(NSMutableArray<FeedResource *> *)resources {
    return [[self feedItemServiceProtocol] feedItemsForResources:resources];
}

- (NSMutableArray<NSString *> *) readingCompliteFeedItemLinks:(NSMutableArray<FeedResource *> *)resources {
    return [[self feedItemServiceProtocol] readingCompliteFeedItemLinks:resources];
}

- (NSMutableArray<NSString *> *) readingInProgressFeedItemLinks:(NSMutableArray<FeedResource *> *)resources {
    return [[self feedItemServiceProtocol] readingInProgressFeedItemLinks:resources];
}

- (void) removeFeedItem:(FeedItem *)item {
    return [[self feedItemServiceProtocol] removeFeedItem:item];
}

- (void) updateFeedItem:(FeedItem *)item {
    return [[self feedItemServiceProtocol] updateFeedItem:item];
}

- (NSMutableArray<FeedItem *> *)feedItemsForResource:(FeedResource *)resource {
    return [[self feedItemServiceProtocol] feedItemsForResource:resource];
}

@end
