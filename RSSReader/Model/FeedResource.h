//
//  FeedResource.h
//  RSSReader
//
//  Created by Dzmitry Noska on 9/3/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedResource : NSObject
@property (strong, nonatomic) NSUUID* identifier;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSURL* url;
- (instancetype)initWithID:(NSUUID *) identifier name:(NSString *) name url:(NSURL *) url;
+ (NSData *) encodeResourceInArray:(FeedResource *) resource;
+ (NSData *) archive:(FeedResource *) resource;
@end
