//
//  CoreDataFeedResourceService.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/10/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "CoreDataFeedResourceService.h"
#import "CoreDataFeedResourceRepository.h"

@interface CoreDataFeedResourceService()
@property (strong, nonatomic) CoreDataFeedResourceRepository* cdFeedResourceRepository;
@end

@implementation CoreDataFeedResourceService

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cdFeedResourceRepository = [[CoreDataFeedResourceRepository alloc] init];
    }
    return self;
}


- (FeedResource *)addFeedResource:(FeedResource *)resource {
    return [self.cdFeedResourceRepository addFeedResource:resource];
}

- (NSMutableArray<FeedResource *> *)feedResources {
    return [self.cdFeedResourceRepository feedResources];
}

- (void)removeFeedResource:(FeedResource *)resource {
    [self.cdFeedResourceRepository removeFeedResource:resource];
}

- (FeedResource *)resourceByURL:(NSURL *)url {
    return [self.cdFeedResourceRepository resourceByURL:url];
}

@end
