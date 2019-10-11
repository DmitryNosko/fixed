//
//  FeedResourceServiceFactory1.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/4/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "FeedResourceServiceFactory.h"
#import "FileFeedResourceService.h"
#import "SQLFeedResourceService.h"
//#import "CoreDataFeedResourceService.h"

@interface FeedResourceServiceFactory()
@property (strong, nonatomic) FileFeedResourceService* fileFeedResourceService;
@property (strong, nonatomic) SQLFeedResourceService* sqlFeedResourceService;
//@property (strong, nonatomic) CoreDataFeedResourceService* cdFeedResourceService;
@end

@implementation FeedResourceServiceFactory

- (instancetype)initWithStorageValue:(NSNumber *) value
{
    self = [super init];
    if (self) {
        _storageValue = value;
        _fileFeedResourceService = [[FileFeedResourceService alloc] init];
        _sqlFeedResourceService = [[SQLFeedResourceService alloc] init];
        //_cdFeedResourceService = [[CoreDataFeedResourceService alloc] init];
    }
    return self;
}

- (id<FeedResourceServiceProtocol>) feedResourceServiceProtocol {
    return self.storageValue.intValue == 0 ? self.fileFeedResourceService : self.sqlFeedResourceService;
}

//- (id<FeedResourceServiceProtocol>) feedResourceServiceProtocol {
//    if (self.storageValue.intValue == 0) {
//        return self.fileFeedResourceService;
//    } else if (self.storageValue.intValue == 1) {
//        return self.sqlFeedResourceService;
//    } else {
//        return self.cdFeedResourceService;
//    }
//}

- (FeedResource *)addFeedResource:(FeedResource *)resource {
    return [[self feedResourceServiceProtocol] addFeedResource:resource];
}

- (NSMutableArray<FeedResource *> *)feedResources {
    return [[self feedResourceServiceProtocol] feedResources];
}

- (void)removeFeedResource:(FeedResource *)resource {
    return [[self feedResourceServiceProtocol] removeFeedResource:resource];
}

- (FeedResource *)resourceByURL:(NSURL *)url {
    return [[self feedResourceServiceProtocol] resourceByURL:url];
}

@end
