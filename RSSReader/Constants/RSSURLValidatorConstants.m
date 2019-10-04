//
//  RSSURLValidatorConstants.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/4/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSURLValidatorConstants.h"

NSString* const PATTERN_FOR_PARSE_FEED_RESOURSES_FROM_URL = @"href=\"([^\"]*)";
NSString* const PATTERN_FOR_UNNECESSARY_SYMBOLS = @"(\W|^)(href=)";
NSString* const RSS_LINK_FORMAT = @".rss";
NSString* const FEED_PREFIX = @"/feed";
