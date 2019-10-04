//
//  FeedResourceServiceFactory1.h
//  RSSReader
//
//  Created by Dzmitry Noska on 10/4/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedResourceServiceProtocol.h"

@interface FeedResourceServiceFactory : NSObject <FeedResourceServiceProtocol>
@property (strong, nonatomic) NSNumber* storageValue;
- (id<FeedResourceServiceProtocol>) feedResourceServiceProtocol;
- (instancetype)initWithStorageValue:(NSNumber *) value;
@end
