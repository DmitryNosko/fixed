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

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.identifier forKey:ITEM_ID_KEY];
    [aCoder encodeObject:self.itemTitle forKey:ITEM_TITLE_KEY];
    [aCoder encodeObject:self.link forKey:ITEM_LINK_KEY];
    [aCoder encodeObject:self.pubDate forKey:ITEM_PUBDATE_KEY];
    [aCoder encodeObject:self.itemDescription forKey:ITEM_DESCRIPTION_KEY];
    [aCoder encodeObject:self.enclosure forKey:ITEM_ENCLOSURE_KEY];
    [aCoder encodeObject:self.imageURL forKey:ITEM_IMAGE_URL_KEY];
    [aCoder encodeObject:self.resourceURL forKey:ITEM_FEED_RESOURCE_URL_KEY];
    [aCoder encodeObject:self.resource forKey:ITEM_FEED_RESOURCE_KEY];
    [aCoder encodeBool:self.isFavorite forKey:ITEM_IS_FAVORITE_KEY];
    [aCoder encodeBool:self.isReadingInProgress forKey:ITEM_IS_READING_IN_PROGRESS_KEY];
    [aCoder encodeBool:self.isReadingComplite forKey:ITEM_IS_READING_COMPLITE_KEY];
    [aCoder encodeBool:self.isAvailable forKey:ITEM_IS_AVAILABLE_KEY];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.identifier = [aDecoder decodeObjectForKey:ITEM_ID_KEY];
        self.itemTitle = [aDecoder decodeObjectForKey:ITEM_TITLE_KEY];
        self.link = [aDecoder decodeObjectForKey:ITEM_LINK_KEY];
        self.pubDate = [aDecoder decodeObjectForKey:ITEM_PUBDATE_KEY];
        self.itemDescription = [aDecoder decodeObjectForKey:ITEM_DESCRIPTION_KEY];
        self.enclosure = [aDecoder decodeObjectForKey:ITEM_ENCLOSURE_KEY];
        self.imageURL = [aDecoder decodeObjectForKey:ITEM_IMAGE_URL_KEY];
        self.resourceURL = [aDecoder decodeObjectForKey:ITEM_FEED_RESOURCE_URL_KEY];
        self.resource = [aDecoder decodeObjectForKey:ITEM_FEED_RESOURCE_KEY];
        self.isFavorite = [aDecoder decodeBoolForKey:ITEM_IS_FAVORITE_KEY];
        self.isReadingInProgress = [aDecoder decodeBoolForKey:ITEM_IS_READING_IN_PROGRESS_KEY];
        self.isReadingComplite = [aDecoder decodeBoolForKey:ITEM_IS_READING_COMPLITE_KEY];
        self.isAvailable = [aDecoder decodeBoolForKey:ITEM_IS_AVAILABLE_KEY];
    }
    return self;
}

- (NSMutableString*) correctDescription:(NSString *) string  {
    NSRegularExpression* regularExpression = [NSRegularExpression regularExpressionWithPattern:PATTERN_FOR_VALIDATION
                                                                                       options:NSRegularExpressionCaseInsensitive
                                                                                            error:nil];
    string = [regularExpression stringByReplacingMatchesInString:string
                                                             options:0
                                                               range:NSMakeRange(0, [string length])
                                                        withTemplate:@""];
    return [string mutableCopy];
}

#pragma mark - Methods

+ (NSData *) encodeItemInArray:(FeedItem *) item {
    return [NSKeyedArchiver archivedDataWithRootObject:[[NSMutableArray alloc] initWithObjects:[NSKeyedArchiver archivedDataWithRootObject:item], nil]];
}

+ (NSData *) archive:(FeedItem *) item {
    return [NSKeyedArchiver archivedDataWithRootObject:item];
}

@end
