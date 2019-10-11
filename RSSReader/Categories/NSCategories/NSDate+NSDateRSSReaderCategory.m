//
//  NSDate+NSDateRSSReaderCategory.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/20/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "NSDate+NSDateRSSReaderCategory.h"

static NSString* const DATE_FORMAT = @"EEE, dd MMM yyyy HH:mm:ss zzz";

@implementation NSDate (NSDateRSSReaderCategory)

- (NSString *) toString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];
    [dateFormatter setDateFormat:DATE_FORMAT];
    return [dateFormatter stringFromDate:self];
}

@end
