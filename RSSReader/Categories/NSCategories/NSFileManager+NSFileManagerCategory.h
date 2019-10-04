//
//  NSFileManager+NSFileManagerCategory.h
//  RSSReader
//
//  Created by Dzmitry Noska on 10/4/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (NSFileManagerCategory)
+ (void) deleteAllDBFiles;
+ (void) deleteAllTXTFiles;
+ (NSString *) documentDirectoryPath;
+ (NSString *) pathForFile:(NSString *) file;
+ (void) removeAllObjectsFormFile:(NSString *) fileName;
@end
