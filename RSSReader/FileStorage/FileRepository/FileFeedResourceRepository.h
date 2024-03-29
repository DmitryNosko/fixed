//
//  FileFeedResourceRepository.h
//  RSSReader
//
//  Created by Dzmitry Noska on 9/20/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileManager.h"

@interface FileFeedResourceRepository : FileManager

- (void)saveFeedResource:(FeedResource*) resource toFileWithName:(NSString*) fileName;
- (NSMutableArray<FeedResource *> *) feedResources:(NSString*) fileName;
- (void) removeFeedResource:(FeedResource *) resource  fromFile:(NSString *) fileName;

@end
