//
//  FileMigrator.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/11/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "FileMigrator.h"
#import "FileFeedResourceService.h"
#import "FileFeedItemService.h"

@implementation FileMigrator

- (NSMutableArray<FeedResource *> *) loadFeedResources {
    return [[[FileFeedResourceService alloc] init] feedResources];
}

- (void)save:(NSMutableArray<FeedResource *> *)resources {
    for (FeedResource* resource in resources) {
        [[[FileFeedResourceService alloc] init] addFeedResource:resource];
        NSMutableArray<FeedItem *>* items = [[[FileFeedItemService alloc] init] allFeedItemsForResources:[[NSMutableArray alloc] initWithObjects:resource, nil]];
        [[[FileFeedItemService alloc] init] cleanSaveFeedItems:items];
    }
}

@end
