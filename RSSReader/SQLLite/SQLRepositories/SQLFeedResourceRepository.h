//
//  FeedResourceRepository.h
//  RSSReader
//
//  Created by Dzmitry Noska on 9/13/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLManager.h"

@interface SQLFeedResourceRepository : SQLManager

- (FeedResource *) addFeedResource:(FeedResource *) resource;
- (void) removeFeedResource:(NSUUID *) resourceID;
- (NSMutableArray<FeedResource *>*) feedResources;
- (FeedResource *) resourceByURL:(NSURL *) url;

@end
