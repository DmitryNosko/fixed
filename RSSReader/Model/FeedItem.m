//
//  FeedItem.m
//  RSSReader
//
//  Created by Dzmitry Noska on 8/30/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "FeedItem.h"
#import "FeedItemConstants.h"

@implementation FeedItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        _itemDescription = [[NSMutableString alloc] init];
        _link = [[NSMutableString alloc] init];
    }
    return self;
}

- (instancetype)initWithID:(NSUUID *) identifier itemTitle:(NSString *) itemTitle link:(NSMutableString *) link pubDate:(NSDate *) pubDate itemDescription:(NSMutableString *) itemDescription enclosure:(NSString *) enclosure imageURL:(NSString *) imageURL isFavorite:(BOOL) isFavorite isReadingInProgress:(BOOL) isReadingInProgress isReadingComplite:(BOOL)isReadingComplite isAvailable:(BOOL) isAvailable resourceURL:(NSURL *) resourceURL resource:(FeedResource *) resource
{
    self = [super init];
    if (self) {
        _identifier = identifier;
        _itemTitle = itemTitle;
        _link = link;
        _pubDate = pubDate;
        _itemDescription = itemDescription;
        _enclosure = enclosure;
        _imageURL = imageURL;
        _isFavorite = isFavorite;
        _isReadingInProgress = isReadingInProgress;
        _isReadingComplite = isReadingComplite;
        _isAvailable = isAvailable;
        _resourceURL = resourceURL;
        _resource = resource;
    }
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.identifier forKey:ITEM_ID_KEY];
    [aCoder encodeObject:self.itemTitle forKey:ITEM_TITLE_KEY];
    [aCoder encodeObject:self.link forKey:LINK_KEY];
    [aCoder encodeObject:self.pubDate forKey:PUBDATE_KEY];
    [aCoder encodeObject:self.itemDescription forKey:ITEM_DESCRIPTION_KEY];
    [aCoder encodeObject:self.enclosure forKey:ENCLOSURE_KEY];
    [aCoder encodeObject:self.imageURL forKey:IMAGE_URL_KEY];
    [aCoder encodeObject:self.resourceURL forKey:FEED_RESOURCE_URL_KEY];
    [aCoder encodeObject:self.resource forKey:FEED_RESOURCE_KEY];
    [aCoder encodeBool:self.isFavorite forKey:IS_FAVORITE_KEY];
    [aCoder encodeBool:self.isReadingInProgress forKey:IS_READING_IN_PROGRESS_KEY];
    [aCoder encodeBool:self.isReadingComplite forKey:IS_READING_COMPLITE_KEY];
    [aCoder encodeBool:self.isAvailable forKey:IS_AVAILABLE_KEY];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.identifier = [aDecoder decodeObjectForKey:ITEM_ID_KEY];
        self.itemTitle = [aDecoder decodeObjectForKey:ITEM_TITLE_KEY];
        self.link = [aDecoder decodeObjectForKey:LINK_KEY];
        self.pubDate = [aDecoder decodeObjectForKey:PUBDATE_KEY];
        self.itemDescription = [aDecoder decodeObjectForKey:ITEM_DESCRIPTION_KEY];
        self.enclosure = [aDecoder decodeObjectForKey:ENCLOSURE_KEY];
        self.imageURL = [aDecoder decodeObjectForKey:IMAGE_URL_KEY];
        self.resourceURL = [aDecoder decodeObjectForKey:FEED_RESOURCE_URL_KEY];
        self.resource = [aDecoder decodeObjectForKey:FEED_RESOURCE_KEY];
        self.isFavorite = [aDecoder decodeBoolForKey:IS_FAVORITE_KEY];
        self.isReadingInProgress = [aDecoder decodeBoolForKey:IS_READING_IN_PROGRESS_KEY];
        self.isReadingComplite = [aDecoder decodeBoolForKey:IS_READING_COMPLITE_KEY];
        self.isAvailable = [aDecoder decodeBoolForKey:IS_AVAILABLE_KEY];
    }
    return self;
}

@end
