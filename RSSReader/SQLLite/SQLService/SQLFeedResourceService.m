//
//  FeedResourceService.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/13/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "SQLFeedResourceService.h"
#import "SQLFeedResourceRepository.h"

@interface SQLFeedResourceService()
@property (strong, nonatomic) SQLFeedResourceRepository* feedResourceRepository;
@end

@implementation SQLFeedResourceService

- (instancetype)init
{
    self = [super init];
    if (self) {
        _feedResourceRepository = [[SQLFeedResourceRepository alloc] init];
    }
    return self;
}

- (FeedResource *) addFeedResource:(FeedResource *) resource {
    return [self.feedResourceRepository addFeedResource:resource];
}

- (void) removeFeedResource:(FeedResource *) resource {
    [self.feedResourceRepository removeFeedResource:resource.identifier];
}

- (NSMutableArray<FeedResource *>*) feedResources {
    return [self.feedResourceRepository feedResources];
}

- (FeedResource *) resourceByURL:(NSURL *) url {
    return [self.feedResourceRepository resourceByURL:url];
}

@end
