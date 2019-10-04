//
//  FileFeedItemRepository.h
//  RSSReader
//
//  Created by Dzmitry Noska on 9/20/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedItem.h"
#import "FeedResource.h"


@interface FileFeedItemRepository : NSObject

- (void)saveFeedItem:(FeedItem*) item toFileWithName:(NSString*) fileName;
- (NSMutableArray<FeedItem *> *) readFeedItemsFile:(NSString*) fileName;
- (void) removeFeedItem:(FeedItem *) item  fromFile:(NSString *) fileName;
- (void)createAndSaveFeedItems:(NSMutableArray<FeedItem*>*) items toFileWithName:(NSString*) fileName;
- (void) updateFeedItem:(FeedItem *) item inFile:(NSString *) fileName;

@end
