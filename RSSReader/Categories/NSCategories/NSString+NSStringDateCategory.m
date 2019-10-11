//
//  NSString+NSStringDateCategory.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/20/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "NSString+NSStringDateCategory.h"

static NSString* VALIDATION_PATTERN_FOR_DESCRIPTION = @"<\/?[A-Za-z]+[^>]*>";


@implementation NSString (NSStringDateCategory)

- (NSDate *)toDate {
    __block NSDate *detectedDate;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingAllTypes error:nil];
    [detector enumerateMatchesInString:self
                               options:kNilOptions
                                 range:NSMakeRange(0, [self length])
                            usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                detectedDate = result.date;
                            }];
    return detectedDate;
}

+ (NSString*) correctDescription:(NSString *) string {
    NSRegularExpression* regularExpression = [NSRegularExpression regularExpressionWithPattern:VALIDATION_PATTERN_FOR_DESCRIPTION
                                                                                       options:NSRegularExpressionCaseInsensitive
                                                                                         error:nil];
    string = [regularExpression stringByReplacingMatchesInString:string
                                                         options:0
                                                           range:NSMakeRange(0, [string length])
                                                    withTemplate:@""];
    return string;
}

@end
