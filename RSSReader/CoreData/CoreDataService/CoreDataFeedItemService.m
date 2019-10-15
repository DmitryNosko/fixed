//
//  CoreDataFeedItemService.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/10/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "CoreDataFeedItemService.h"
#import "CoreDataFeedItemRepository.h"
#import "CoreDataFeedResourceRepository.h"

@interface CoreDataFeedItemService()
@property (strong, nonatomic) CoreDataFeedItemRepository* cdFeedItemRepository;
@property (strong, nonatomic) CoreDataFeedResourceRepository* cdFeedResourceRepository;
@end

@implementation CoreDataFeedItemService

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cdFeedItemRepository = [[CoreDataFeedItemRepository alloc] init];
        _cdFeedResourceRepository = [[CoreDataFeedResourceRepository alloc] init];
    }
    return self;
}

- (NSMutableArray<FeedItem *> *)allFeedItemsForResources:(NSMutableArray<FeedResource *> *)resources { 
    return [self.cdFeedItemRepository allFeedItemsForResources:resources];
}

- (NSMutableArray<FeedItem *> *)cleanSaveFeedItems:(NSMutableArray<FeedItem *> *)items {
    //FeedItem* item = [items firstObject];
    NSURL* resURL = [items firstObject].resourceURL;
    FeedResource* resource = [self.cdFeedResourceRepository resourceByURL:resURL];
    [self.cdFeedItemRepository removeFeedItemForResource:resource.identifier];
    NSMutableArray<FeedItem *>* createdItems = [self addFeedItems:items];
    return createdItems;
}

- (NSMutableArray<FeedItem *> *) addFeedItems:(NSMutableArray<FeedItem *>*) items {
    NSMutableArray<FeedItem *>* resultItems = [[NSMutableArray alloc] init];
    for (FeedItem* item in items) {
        [resultItems addObject:[self.cdFeedItemRepository addFeedItem:item]];
    }
    return resultItems;
}

- (NSMutableArray<NSString *> *)favoriteFeedItemLinks:(NSMutableArray<FeedResource *> *)resources { 
    return [self.cdFeedItemRepository favoriteFeedItemLinks:resources];
}

- (NSMutableArray<FeedItem *> *)favoriteFeedItems:(NSMutableArray<FeedResource *> *)resources { 
    return [self.cdFeedItemRepository favoriteFeedItems:resources];
}

- (NSMutableArray<FeedItem *> *)feedItemsForResource:(FeedResource *)resource { 
    return [self.cdFeedItemRepository feedItemsForResource:resource.identifier];
}

- (NSMutableArray<FeedItem *> *)feedItemsForResources:(NSMutableArray<FeedResource *> *)resources { 
    return [self.cdFeedItemRepository feedItemsForResources:resources];
}

- (NSMutableArray<NSString *> *)readingCompliteFeedItemLinks:(NSMutableArray<FeedResource *> *)resources { 
    return [self.cdFeedItemRepository readingCompliteFeedItemLinks:resources];
}

- (NSMutableArray<NSString *> *)readingInProgressFeedItemLinks:(NSMutableArray<FeedResource *> *)resources { 
    return [self.cdFeedItemRepository readingInProgressFeedItemLinks:resources];
}

- (void)removeFeedItem:(FeedItem *)item { 
    [self.cdFeedItemRepository removeFeedItem:item];
}

- (void)updateFeedItem:(FeedItem *)item { 
    [self.cdFeedItemRepository updateFeedItem:item];
}

@end
