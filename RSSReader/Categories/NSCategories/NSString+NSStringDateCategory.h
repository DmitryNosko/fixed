//
//  NSString+NSStringDateCategory.h
//  RSSReader
//
//  Created by Dzmitry Noska on 9/20/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSStringDateCategory)
- (NSDate *)toDate;
+ (NSString*) correctDescription:(NSString *) string;
@end

