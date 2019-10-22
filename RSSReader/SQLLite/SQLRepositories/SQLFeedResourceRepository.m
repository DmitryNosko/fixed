//
//  FeedResourceRepository.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/13/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "SQLFeedResourceRepository.h"
#import "SQLFeedResourceRepositoryConstants.h"

@implementation SQLFeedResourceRepository

#pragma mark - FeedResource Requests

- (FeedResource *) addFeedResource:(FeedResource *) resource {
    const char *insertStatement = [[NSString stringWithFormat:INSERT_FEEDRESOURCE_SQL, [resource.identifier UUIDString], resource.name, [resource.url absoluteString]] UTF8String];
    [self sqlRequestWithDBPath:[self dataBasePath] db:rssDataBase request:insertStatement];
    return resource;
}

- (void) removeFeedResource:(NSUUID *) resourceID {
    const char *removeStatement = [[NSString stringWithFormat:DELETE_FEEDRESOURCE_SQL, [resourceID UUIDString]] UTF8String];
    [self sqlRequestWithDBPath:[self dataBasePath] db:rssDataBase request:removeStatement];
}

- (NSMutableArray<FeedResource *>*) feedResources {
    return [self resourcesFromRequest:SELECT_FEEDRESOURCE_SQL];
}

- (FeedResource *) resourceByURL:(NSURL *) url {
    return [[self resourcesFromRequest:[[NSString stringWithFormat:SELECT_FEEDRESOURSE_BY_URL, url.absoluteString] UTF8String]] firstObject];
}

@end
