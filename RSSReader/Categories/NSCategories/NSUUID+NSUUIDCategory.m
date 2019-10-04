//
//  NSUUID+NSUUIDCategory.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/4/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "NSUUID+NSUUIDCategory.h"

@implementation NSUUID (NSUUIDCategory)

+ (NSMutableArray<NSString *>*) toString:(NSMutableArray<NSUUID *>*) uuids {
    NSMutableArray<NSString *>* stringIDs = [[NSMutableArray alloc] init];
    for (NSUUID* uid in uuids) {
        [stringIDs addObject:[uid UUIDString]];
    }
    return stringIDs;
}

@end
