//
//  FileManager.h
//  RSSReader
//
//  Created by USER on 10/20/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSFileManager+NSFileManagerCategory.h"
#import "FeedItem.h"
#import "FeedResource.h"

@interface FileManager : NSObject
@property (strong, nonatomic) NSFileManager* fileManager;
@end
