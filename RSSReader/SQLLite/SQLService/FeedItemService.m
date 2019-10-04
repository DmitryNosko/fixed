//
//  FeedItemService.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/13/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "SQLFeedItemService.h"
#import "SQLFeedItemRepository.h"

@interface SQLFeedItemService()
@property (strong, nonatomic) SQLFeedItemRepository* feedItemRepository;
@end

@implementation SQLFeedItemService

- (instancetype)init
{
    self = [super init];
    if (self) {
        _feedItemRepository = [SQLFeedItemRepository sharedFeedItemRepository];
    }
    return self;
}

- (NSMutableArray<FeedItem *>*) cleanSaveFeedItems:(NSMutableArray<FeedItem *>*) items {
    [self.feedItemRepository removeAllFeedItems];
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

- (NSMutableArray<FeedItem *>*) feedItems {
    return [self.feedItemRepository feedItems];
}

- (void)updateFeedItem:(FeedItem *)item {
    [self.feedItemRepository updateFeedItem:item];
}

- (void) removeFeedItem:(FeedItem *) item {
    [self.feedItemRepository removeFeedItem:item];
}

@end
