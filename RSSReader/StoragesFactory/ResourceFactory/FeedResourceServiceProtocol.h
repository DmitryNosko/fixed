//
//  FeedResourceServiceProtocol.h
//  RSSReader
//
//  Created by Dzmitry Noska on 9/20/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedResource.h"

@protocol FeedResourceServiceProtocol <NSObject>
- (FeedResource *) addFeedResource:(FeedResource *) resource;
- (void) removeFeedResource:(FeedResource *) resource;
- (NSMutableArray<FeedResource *>*) feedResources;
- (FeedResource *) resourceByURL:(NSURL *) url;
@end
