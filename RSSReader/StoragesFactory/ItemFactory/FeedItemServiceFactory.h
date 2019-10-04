//
//  FeedItemServiceFactory1.h
//  RSSReader
//
//  Created by Dzmitry Noska on 10/4/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedItemServiceProtocol.h"

@interface FeedItemServiceFactory : NSObject <FeedItemServiceProtocol>
@property (strong, nonatomic) NSNumber* storageValue;
- (id<FeedItemServiceProtocol>) feedItemServiceProtocol;
- (instancetype)initWithStorageValue:(NSNumber *) value;
@end
