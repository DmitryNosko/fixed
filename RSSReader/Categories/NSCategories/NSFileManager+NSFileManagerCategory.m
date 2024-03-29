//
//  NSFileManager+NSFileManagerCategory.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/4/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "NSFileManager+NSFileManagerCategory.h"

static NSString* const DB_FILE_EXTENSION = @"db";
static NSString* const TXT_FILE_EXTENSION = @"txt";
static NSString* const SQLITE_FILE_EXTENSION = @"sqlite";

@implementation NSFileManager (NSFileManagerCategory)

+ (void) deleteAllDBFiles {
    [self deleteFileByFormat:DB_FILE_EXTENSION];
}

+ (void) deleteAllTXTFiles {
    [self deleteFileByFormat:TXT_FILE_EXTENSION];
}

+ (void) deleteAllSQLITEFiles {
    [self deleteFileByFormat:SQLITE_FILE_EXTENSION];
}

+ (void) deleteFileByFormat:(NSString *) format {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        
        if ([[filename pathExtension] isEqualToString:format]) {
            
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}

+ (NSURL *) applicationDocumentDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *) documentDirectoryPath {
    return [ NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *) pathForFile:(NSString *) file {
    return [[self documentDirectoryPath] stringByAppendingPathComponent:file];
}

+ (void) removeAllObjectsFormFile:(NSString *)fileName {
    [[[NSFileManager alloc] init] createFileAtPath:[self pathForFile:fileName] contents:nil attributes:nil];
}

@end
