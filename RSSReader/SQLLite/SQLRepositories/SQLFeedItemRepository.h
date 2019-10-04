//
//  FeedItemRepository.h
//  RSSReader
//
//  Created by Dzmitry Noska on 9/13/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLManager.h"

@interface SQLFeedItemRepository : SQLManager

- (FeedItem *) addFeedItem:(FeedItem *) item;
- (NSMutableArray<FeedItem *>*) feedItemsForResource:(NSUUID *) identifier;
- (NSMutableArray<FeedItem *>*) feedItemsForResources:(NSMutableArray<NSUUID *>*) resourcesIDs;
- (NSMutableArray<FeedItem *>*) allFeedItemsForResources:(NSMutableArray<NSUUID *>*) resourcesIDs;
- (void) updateFeedItem:(FeedItem *) item;
- (void) removeFeedItem:(FeedItem *) item;
- (void) removeFeedItemForResource:(NSUUID *) identifier;
- (void) removeAllFeedItems;
- (NSMutableArray<FeedItem *>*) favoriteFeedItems:(NSMutableArray<NSUUID *>*) resourcesIDs;
- (NSMutableArray<NSString *>*) favoriteFeedItemLinks:(NSMutableArray<NSUUID *>*) resourcesIDs;
- (NSMutableArray<NSString *>*) readingInProgressFeedItemLinks:(NSMutableArray<NSUUID *>*) resourcesIDs;
- (NSMutableArray<NSString *>*) readingCompliteFeedItemLinks:(NSMutableArray<NSUUID *>*) resourcesIDs;

@end
