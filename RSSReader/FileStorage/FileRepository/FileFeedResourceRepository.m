//
//  FileFeedResourceRepository.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/20/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "FileFeedResourceRepository.h"
#import "NSFileManager+NSFileManagerCategory.h"

@interface FileFeedResourceRepository()
@property (strong, nonatomic) NSFileManager* fileManager;
@end

@implementation FileFeedResourceRepository

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fileManager = [NSFileManager defaultManager];
    }
    return self;
}

#pragma mark - FeedResource

- (void)saveFeedResource:(FeedResource*) resource toFileWithName:(NSString*) fileName {
    if (resource) {
        NSMutableArray* encodedResource = [[NSMutableArray alloc] initWithObjects:[NSKeyedArchiver archivedDataWithRootObject:resource], nil];
        
        NSData* encodedArray = [NSKeyedArchiver archivedDataWithRootObject:encodedResource];
        
        NSString* filePath = [NSFileManager pathForFile:fileName];
        
        if ([self.fileManager fileExistsAtPath:filePath]) {
            
            NSMutableArray<FeedResource *>* decodedResources = [self feedResources:fileName];
            NSMutableArray<NSData *>* encodedFileContent = [[NSMutableArray alloc] init];
            for (FeedResource* decodedResource in decodedResources) {
                [encodedFileContent addObject:[NSKeyedArchiver archivedDataWithRootObject:decodedResource]];
            }
            
            [encodedFileContent addObject:[NSKeyedArchiver archivedDataWithRootObject:resource]];
            
            NSData* encodedFileData = [NSKeyedArchiver archivedDataWithRootObject:encodedFileContent];
            [encodedFileData writeToFile:filePath atomically:YES];
            
        } else {
            [self.fileManager createFileAtPath:filePath contents:encodedArray attributes:nil];
        }
    }
}

- (NSMutableArray<FeedResource *> *) feedResources:(NSString*) fileName {
    NSData* fileContent = [[NSFileHandle fileHandleForReadingAtPath:[NSFileManager pathForFile:fileName]] readDataToEndOfFile];
    
    NSMutableArray<NSData *>* encodedObjects = [NSKeyedUnarchiver unarchiveObjectWithData:fileContent];
    NSMutableArray<FeedResource *>* decodedResources = [[NSMutableArray alloc] init];
    
    for (NSData* data in encodedObjects) {
        FeedResource* resource = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [decodedResources addObject:resource];
    }
    
    return decodedResources;
}

- (void) removeFeedResource:(FeedResource *) resource  fromFile:(NSString *) fileName {
    NSMutableArray<FeedResource *>* resorces = [self feedResources:fileName];
    
    for (FeedResource* feedResource in [resorces copy]) {
        if ([feedResource.identifier isEqual:resource.identifier]) {
            [resorces removeObject:feedResource];
        }
    }
    
    [NSFileManager removeAllObjectsFormFile:fileName];
    
    for (FeedResource* fR in [resorces copy]) {
        [self saveFeedResource:fR toFileWithName:fileName];
    }
}


@end
