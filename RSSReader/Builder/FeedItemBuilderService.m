//
//  FeedItemBuilderService.m
//  RSSReader
//
//  Created by USER on 10/22/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "FeedItemBuilderService.h"

@interface FeedItemBuilderService()
@property (strong, nonatomic) FeedItem* item;
@end

@implementation FeedItemBuilderService

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.item = [[FeedItem alloc] init];
    }
    return self;
}

- (instancetype)buildEnclosure:(NSString *)enclosure {
    self.item.enclosure = enclosure;
    return self;
}

- (FeedItem *)buildFeedItem {
    return self.item;
}

- (instancetype)buildIdentifier:(NSUUID *)identifier {
    self.item.identifier = identifier;
    return self;
}

- (instancetype)buildImageURL:(NSString *)imageURL {
    self.item.imageURL = imageURL;
    return self;
}

- (instancetype)buildIsAvailable:(BOOL)isAvailable {
    self.item.isAvailable = isAvailable;
    return self;
}

- (instancetype)buildIsFavorite:(BOOL)isFavorite {
    self.item.isFavorite = isFavorite;
    return self;
}

- (instancetype)buildIsReadingComplite:(BOOL)isReadingComplite {
    self.item.isReadingComplite = isReadingComplite;
    return self;
}

- (instancetype)buildIsReadingInProgress:(BOOL)isReadingInProgress {
    self.item.isReadingInProgress = isReadingInProgress;
    return self;
}

- (instancetype)buildItemDescription:(NSMutableString *)itemDescription {
    self.item.itemDescription = itemDescription;
    return self;
}

- (instancetype)buildItemTitle:(NSString *)itemTitle {
    self.item.itemTitle = itemTitle;
    return self;
}

- (instancetype)buildLink:(NSMutableString *)link {
    self.item.link = link;
    return self;
}

- (instancetype)buildPubDate:(NSDate *)pubDate {
    self.item.pubDate = pubDate;
    return self;
}

- (instancetype)buildResource:(FeedResource *)resource {
    self.item.resource = resource;
    return self;
}

- (instancetype)buildResourceURL:(NSURL *)resourceURL {
    self.item.resourceURL = resourceURL;
    return self;
}

@end
