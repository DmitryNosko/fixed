//
//  FileToSQLDatasourceMigrator.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/20/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "FileToSQLDatasourceMigrator.h"
#import "SQLFeedItemService.h"
#import "SQLFeedResourceService.h"
#import "FileFeedItemService.h"
#import "FileFeedResourceService.h"
#import "NSFileManager+NSFileManagerCategory.h"
#import "SQLManager.h"

@implementation FileToSQLDatasourceMigrator

- (void) migrateData {
    [[[SQLManager alloc] init] createDB];
    
    NSMutableArray<FeedResource *>* fileResources = [[[FileFeedResourceService alloc] init] feedResources];
    
    for (FeedResource* fileResource in fileResources) {
        [[[SQLFeedResourceService alloc] init] addFeedResource:fileResource];
    }
    
    [[[SQLFeedItemService alloc] init] cleanSaveFeedItems:[[[FileFeedItemService alloc] init] allFeedItemsForResources:fileResources]];
    [NSFileManager deleteAllTXTFiles];
}



@end
