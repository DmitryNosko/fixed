//
//  CoreDataMigrator.m
//  RSSReader
//
//  Created by USER on 10/13/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "CoreDataMigrator.h"
#import "CoreDataFeedItemService.h"
#import "CoreDataFeedResourceService.h"
#import "NSFileManager+NSFileManagerCategory.h"
#import "SQLManager.h"

@interface CoreDataMigrator()
@property (strong, nonatomic) id<FeedItemServiceProtocol> itemService;
@property (strong, nonatomic) id<FeedResourceServiceProtocol> resourceService;
@property (strong, nonatomic) CoreDataFeedResourceService* cdResourceService;
@property (strong, nonatomic) CoreDataFeedItemService* cdItemService;
@end

@implementation CoreDataMigrator

- (instancetype)initWithResource:(id<FeedResourceServiceProtocol>) resourceService andItemService:(id<FeedItemServiceProtocol>) itemService
{
    self = [super init];
    if (self) {
        _resourceService = resourceService;
        _itemService = itemService;
        _cdItemService = [[CoreDataFeedItemService alloc] init];
        _cdResourceService = [[CoreDataFeedResourceService alloc] init];
    }
    return self;
}

- (void)migrateData {

    //[[[SQLManager alloc] init] createDB];
    
    NSMutableArray<FeedResource *>* fileResources = [self.resourceService feedResources];
    
    for (FeedResource* fileResource in fileResources) {
        [self.cdResourceService addFeedResource:fileResource];
    }
    
    [self.cdItemService cleanSaveFeedItems:[self.itemService allFeedItemsForResources:fileResources]];
    [NSFileManager deleteAllDBFiles];
    [NSFileManager deleteAllTXTFiles];
}

@end
