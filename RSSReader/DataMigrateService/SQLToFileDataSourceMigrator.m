//
//  SQLToFileDataSourceMigrator.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/20/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "SQLToFileDataSourceMigrator.h"
#import "SQLFeedItemService.h"
#import "SQLFeedResourceService.h"
#import "FileFeedItemService.h"
#import "FileFeedResourceService.h"
#import "NSFileManager+NSFileManagerCategory.h"

@implementation SQLToFileDataSourceMigrator

- (void) migrateData {
    NSMutableArray<FeedResource *>* sqlResources = [[[SQLFeedResourceService alloc] init] feedResources];
    
    for (FeedResource* sqlResource in sqlResources) {
        [[[FileFeedResourceService alloc] init] addFeedResource:sqlResource];
        NSMutableArray<FeedResource *>* resources = [[NSMutableArray alloc] initWithObjects:sqlResource, nil];
         [[[FileFeedItemService alloc] init] cleanSaveFeedItems:[[[SQLFeedItemService alloc] init] allFeedItemsForResources:resources]];
    }
    
    [NSFileManager deleteAllDBFiles];
}

@end
