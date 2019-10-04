//
//  SQLFeedItemService.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/20/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "SQLFeedItemService.h"
#import "SQLFeedItemRepository.h"

static NSString* const RESOURCE_IDENTIFIER = @"identifier";

@interface SQLFeedItemService()
@property (strong, nonatomic) SQLFeedItemRepository* feedItemRepository;
@end

@implementation SQLFeedItemService

- (instancetype)init
{
    self = [super init];
    if (self) {
        _feedItemRepository = [[SQLFeedItemRepository alloc] init];
    }
    return self;
}

- (NSMutableArray<FeedItem *> *) cleanSaveFeedItems:(NSMutableArray<FeedItem *>*) items {
    FeedResource* resource = [items firstObject].resource;
    [self.feedItemRepository removeFeedItemForResource:resource.identifier];
    NSMutableArray<FeedItem *>* createdItems = [self addFeedItems:items];
    return createdItems;
}

- (NSMutableArray<FeedItem *> *) addFeedItems:(NSMutableArray<FeedItem *>*) items {
    NSMutableArray<FeedItem *>* resultItems = [[NSMutableArray alloc] init];
    for (FeedItem* item in items) {
        [resultItems addObject:[self addFeedItem:item]];
    }
    return resultItems;
}

- (FeedItem *) addFeedItem:(FeedItem *) item {
    return [self.feedItemRepository addFeedItem:item];
}

- (NSMutableArray<FeedItem *>*) feedItemsForResource:(FeedResource *) resource {
    return [self.feedItemRepository feedItemsForResource:resource.identifier];
}

- (NSMutableArray<FeedItem *>*) feedItemsForResources:(NSMutableArray<FeedResource *>*) resources {
    return [self.feedItemRepository feedItemsForResources:[resources valueForKey:RESOURCE_IDENTIFIER]];
}

- (NSMutableArray<FeedItem *> *) allFeedItemsForResources:(NSMutableArray<FeedResource *> *)resources {
    return [self.feedItemRepository allFeedItemsForResources:[resources valueForKey:RESOURCE_IDENTIFIER]];
}

- (void)updateFeedItem:(FeedItem *) item {
    [self.feedItemRepository updateFeedItem:item];
}

- (void) removeFeedItem:(FeedItem *) item {
    [self.feedItemRepository removeFeedItem:item];
}

- (NSMutableArray<FeedItem *>*) favoriteFeedItems:(NSMutableArray<FeedResource *>*) resources {
    return [self.feedItemRepository favoriteFeedItems:[resources valueForKey:RESOURCE_IDENTIFIER]];
}

- (NSMutableArray<NSString *>*) favoriteFeedItemLinks:(NSMutableArray<FeedResource *>*) resources {
    return [self.feedItemRepository favoriteFeedItemLinks:[resources valueForKey:RESOURCE_IDENTIFIER]];
}

- (NSMutableArray<NSString *>*) readingInProgressFeedItemLinks:(NSMutableArray<FeedResource *>*) resources {
    return [self.feedItemRepository readingInProgressFeedItemLinks:[resources valueForKey:RESOURCE_IDENTIFIER]];
}

- (NSMutableArray<NSString *>*) readingCompliteFeedItemLinks:(NSMutableArray<FeedResource *>*) resources {
    return [self.feedItemRepository readingCompliteFeedItemLinks:[resources valueForKey:RESOURCE_IDENTIFIER]];
}

@end
