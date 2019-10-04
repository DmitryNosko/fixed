//
//  FeedResource.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/3/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "FeedResource.h"
#import "FeedResourceConstants.h"

@implementation FeedResource

- (instancetype)initWithName:(NSString*) name url:(NSURL*) url
{
    self = [super init];
    if (self) {
        _name = name;
        _url = url;
    }
    return self;
}

- (instancetype)initWithID:(NSUUID *) identifier name:(NSString*) name url:(NSURL*) url
{
    self = [super init];
    if (self) {
        _identifier = identifier;
        _name = name;
        _url = url;
    }
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.identifier forKey:ID_KEY];
    [aCoder encodeObject:self.name forKey:NAME_KEY];
    [aCoder encodeObject:self.url forKey:URL_KEY];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.identifier = [aDecoder decodeObjectForKey:ID_KEY];
        self.name = [aDecoder decodeObjectForKey:NAME_KEY];
        self.url = [aDecoder decodeObjectForKey:URL_KEY];
    }
    return self;
}

@end
