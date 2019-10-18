//
//  CoreDataFeedItemRepository.h
//  RSSReader
//
//  Created by Dzmitry Noska on 10/10/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataController.h"
#import "FeedItem.h"
#import "FeedResource.h"

@interface CoreDataFeedItemRepository : CoreDataController

- (NSMutableArray<FeedItem *>*) feedItemsForResources:(NSMutableArray<FeedResource *>*) resources;
- (NSMutableArray<FeedItem *>*) allFeedItemsForResources:(NSMutableArray<FeedResource *>*) resources;
- (NSMutableArray<FeedItem *>*) favoriteFeedItems:(NSMutableArray<FeedResource *>*) resources;
- (NSMutableArray<NSString *>*) favoriteFeedItemLinks:(NSMutableArray<FeedResource *>*) resources;
- (NSMutableArray<NSString *>*) readingInProgressFeedItemLinks:(NSMutableArray<FeedResource *>*) resources;
- (NSMutableArray<NSString *>*) readingCompliteFeedItemLinks:(NSMutableArray<FeedResource *>*) resources;
- (FeedItem *) addFeedItem:(FeedItem *) item;
- (NSMutableArray<FeedItem *>*) feedItemsForResource:(NSUUID *) identifier;
- (void) updateFeedItem:(FeedItem *) item;
- (void) removeFeedItem:(FeedItem *) item;
- (void) removeFeedItemForResource:(NSUUID *) identifier;
- (void) removeAllFeedItems;

@end
