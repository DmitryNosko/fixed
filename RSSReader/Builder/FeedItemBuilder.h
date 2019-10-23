//
//  FeedItemBuilder.h
//  RSSReader
//
//  Created by USER on 10/22/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedItem.h"
#import "FeedResource.h"

@protocol FeedItemBuilder <NSObject>
- (instancetype) buildIdentifier:(NSUUID *) identifier;
- (instancetype) buildItemTitle:(NSString *) itemTitle;
- (instancetype) buildLink:(NSMutableString *) link;
- (instancetype) buildPubDate:(NSDate *) pubDate;
- (instancetype) buildItemDescription:(NSMutableString *) itemDescription;
- (instancetype) buildEnclosure:(NSString *) enclosure;
- (instancetype) buildImageURL:(NSString *) imageURL;
- (instancetype) buildIsFavorite:(BOOL) isFavorite;
- (instancetype) buildIsReadingInProgress:(BOOL) isReadingInProgress;
- (instancetype) buildIsReadingComplite:(BOOL) isReadingComplite;
- (instancetype) buildIsAvailable:(BOOL) isAvailable;
- (instancetype) buildResourceURL:(NSURL *) resourceURL;
- (instancetype) buildResource:(FeedResource *) resource;
- (FeedItem *) buildFeedItem;

@end
