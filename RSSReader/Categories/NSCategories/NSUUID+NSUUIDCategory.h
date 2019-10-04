//
//  NSUUID+NSUUIDCategory.h
//  RSSReader
//
//  Created by Dzmitry Noska on 10/4/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUUID (NSUUIDCategory)
+ (NSMutableArray<NSString *>*) toString:(NSMutableArray<NSUUID *>*) uuids;
@end
