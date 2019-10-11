//
//  CoreDataFeedResourceRepository.h
//  RSSReader
//
//  Created by Dzmitry Noska on 10/10/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataController.h"
#import "FeedResource.h"

@interface CoreDataFeedResourceRepository : CoreDataController

- (FeedResource *) addFeedResource:(FeedResource *) resource;
- (void) removeFeedResource:(FeedResource *) resource;
- (NSMutableArray<FeedResource *>*) feedResources;
- (FeedResource *) resourceByURL:(NSURL *) url;

@end
