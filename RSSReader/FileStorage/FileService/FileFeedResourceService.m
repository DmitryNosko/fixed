//
//  FileFeedResourceService.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/20/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "FileFeedResourceService.h"
#import "FileFeedResourceRepository.h"

@interface FileFeedResourceService ()
@property (strong, nonatomic) FileFeedResourceRepository* fileFeedResourceRepository;
@end

static NSString* const MENU_FILE_NAME = @"MainMenuFile.txt";

@implementation FileFeedResourceService

static FileFeedResourceService* shared;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fileFeedResourceRepository = [[FileFeedResourceRepository alloc] init];
    }
    return self;
}

- (FeedResource *) addFeedResource:(FeedResource *) resource {
    [self.fileFeedResourceRepository saveFeedResource:resource toFileWithName:MENU_FILE_NAME];
    return resource;
}

- (void) removeFeedResource:(FeedResource *) resource {
    [self.fileFeedResourceRepository removeFeedResource:resource fromFile:MENU_FILE_NAME];
}

- (NSMutableArray<FeedResource *>*) feedResources {
    return [self.fileFeedResourceRepository feedResources:MENU_FILE_NAME];
}

- (FeedResource *) resourceByURL:(NSURL *) url {
    
    NSMutableArray<FeedResource *>* resources = [self.fileFeedResourceRepository feedResources:MENU_FILE_NAME];
    FeedResource* res = nil;
    for (FeedResource* resource in resources) {
        if ([[resource.url absoluteString] isEqualToString:[url absoluteString]]) {
            res = resource;
        }
    }
    return res;
}

@end
