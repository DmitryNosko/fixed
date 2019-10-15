//
//  FileToSQLDatasourceMigrator.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/20/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "SQLDatasourceMigrator.h"
#import "SQLFeedItemService.h"
#import "SQLFeedResourceService.h"
#import "FileFeedItemService.h"
#import "FileFeedResourceService.h"
#import "NSFileManager+NSFileManagerCategory.h"
#import "SQLManager.h"

@interface SQLDatasourceMigrator()
@property (strong, nonatomic) id<FeedItemServiceProtocol> itemService;
@property (strong, nonatomic) id<FeedResourceServiceProtocol> resourceService;
@property (strong, nonatomic) SQLFeedResourceService* sqlResourceService;
@property (strong, nonatomic) SQLFeedItemService* sqlItemService;
@end

@implementation SQLDatasourceMigrator

- (instancetype)initWithResource:(id<FeedResourceServiceProtocol>) resourceService andItemService:(id<FeedItemServiceProtocol>) itemService
{
    self = [super init];
    if (self) {
        _resourceService = resourceService;
        _itemService = itemService;
        _sqlItemService = [[SQLFeedItemService alloc] init];
        _sqlResourceService = [[SQLFeedResourceService alloc] init];
    }
    return self;
}

- (void) migrateData {
    [[[SQLManager alloc] init] createDB];
    
    NSMutableArray<FeedResource *>* fileResources = [self.resourceService feedResources];
    
    for (FeedResource* fileResource in fileResources) {
        [self.sqlResourceService addFeedResource:fileResource];
    }
    
    [self.sqlItemService cleanSaveFeedItems:[self.itemService allFeedItemsForResources:fileResources]];
    [NSFileManager deleteAllSQLITEFiles];
    [NSFileManager deleteAllTXTFiles];
}

@end
