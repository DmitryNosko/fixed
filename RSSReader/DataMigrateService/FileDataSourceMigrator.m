//
//  SQLToFileDataSourceMigrator.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/20/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "FileDataSourceMigrator.h"
#import "SQLFeedItemService.h"
#import "SQLFeedResourceService.h"
#import "FileFeedItemService.h"
#import "FileFeedResourceService.h"
#import "NSFileManager+NSFileManagerCategory.h"

@interface FileDataSourceMigrator()
@property (strong, nonatomic) id<FeedItemServiceProtocol> itemService;
@property (strong, nonatomic) id<FeedResourceServiceProtocol> resourceService;
@property (strong, nonatomic) FileFeedResourceService* fileResourceService;
@property (strong, nonatomic) FileFeedItemService* fileItemService;
@end

@implementation FileDataSourceMigrator

- (instancetype)initWithResource:(id<FeedResourceServiceProtocol>) resourceService andItemService:(id<FeedItemServiceProtocol>) itemService
{
    self = [super init];
    if (self) {
        _resourceService = resourceService;
        _itemService = itemService;
        _fileItemService = [[FileFeedItemService alloc] init];
        _fileResourceService = [[FileFeedResourceService alloc] init];
    }
    return self;
}

- (void) migrateData {
    NSMutableArray<FeedResource *>* sqlResources = [self.resourceService feedResources];
    
    for (FeedResource* sqlResource in sqlResources) {
        [self.fileResourceService addFeedResource:sqlResource];
        NSMutableArray<FeedResource *>* resources = [[NSMutableArray alloc] initWithObjects:sqlResource, nil];
         [self.fileItemService cleanSaveFeedItems:[self.itemService allFeedItemsForResources:resources]];
    }
    
    [NSFileManager deleteAllDBFiles];
}

@end
