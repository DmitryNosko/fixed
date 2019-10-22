//
//  FeedItemConstants.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/4/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedItemConstants.h"

NSString* const ITEM_ID_KEY = @"identifier";
NSString* const ITEM_TITLE_KEY = @"itemTitle";
NSString* const ITEM_LINK_KEY = @"link";
NSString* const ITEM_PUBDATE_KEY = @"pubDate";
NSString* const ITEM_DESCRIPTION_KEY = @"itemDescription";
NSString* const ITEM_ENCLOSURE_KEY = @"enclosure";
NSString* const ITEM_IMAGE_URL_KEY = @"imageURL";
NSString* const ITEM_IS_FAVORITE_KEY = @"isFavorite";
NSString* const ITEM_IS_READING_IN_PROGRESS_KEY = @"isReadingInProgress";
NSString* const ITEM_IS_READING_COMPLITE_KEY = @"isReadingComplite";
NSString* const ITEM_IS_AVAILABLE_KEY = @"isAvailable";
NSString* const ITEM_FEED_RESOURCE_URL_KEY = @"resourceURL";
NSString* const ITEM_FEED_RESOURCE_KEY = @"resource";
NSString* const ITEM_CORE_DATA_NAME = @"CDFeedItem";
NSString* const PATTERN_FOR_VALIDATION = @"<\/?[A-Za-z]+[^>]*>";

NSString* const ITEM_TAG = @"item";
NSString* const URL_TAG = @"url";
NSString* const TITLE_TAG = @"title";
NSString* const DESCRIPTION_TAG = @"description";
