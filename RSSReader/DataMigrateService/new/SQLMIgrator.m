//
//  SQLMIgrator.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/11/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "SQLMIgrator.h"
#import "SQLFeedResourceService.h"
#import "SQLFeedItemService.h"

@implementation SQLMIgrator

- (NSMutableArray<FeedResource *> *)loadFeedResources {
   return [[[SQLFeedResourceService alloc] init] feedResources];
}

- (void) save:(NSMutableArray<FeedResource *> *)resources {
    for (FeedResource* sqlResource in resources) {
        [[[SQLFeedResourceService alloc] init] addFeedResource:sqlResource];
        NSMutableArray<FeedItem *>* items = [[[SQLFeedItemService alloc] init] allFeedItemsForResources:[[NSMutableArray alloc] initWithObjects:sqlResource, nil]];
        [[[SQLFeedItemService alloc] init] cleanSaveFeedItems:items];
    }
}

@end
