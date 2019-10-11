//
//  Reachability+ReachabilityCategory.h
//  RSSReader
//
//  Created by Dzmitry Noska on 10/7/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "Reachability.h"

@interface Reachability (ReachabilityCategory)
+ (BOOL) hasInternerConnection;
@end

