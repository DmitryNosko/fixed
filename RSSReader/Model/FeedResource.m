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
    [aCoder encodeObject:self.identifier forKey:RESOURCE_ID_KEY];
    [aCoder encodeObject:self.name forKey:RESOURCE_NAME_KEY];
    [aCoder encodeObject:self.url forKey:RESOURCE_URL_KEY];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.identifier = [aDecoder decodeObjectForKey:RESOURCE_ID_KEY];
        self.name = [aDecoder decodeObjectForKey:RESOURCE_NAME_KEY];
        self.url = [aDecoder decodeObjectForKey:RESOURCE_URL_KEY];
    }
    return self;
}

@end
