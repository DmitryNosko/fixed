//
//  Reachability+ReachabilityCategory.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/7/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "Reachability+ReachabilityCategory.h"

@implementation Reachability (ReachabilityCategory)
+ (BOOL) hasInternerConnection {
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus* status = [reachability currentReachabilityStatus];
    return status != NotReachable;
}
@end
