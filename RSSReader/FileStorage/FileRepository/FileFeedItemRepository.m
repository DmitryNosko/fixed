//
//  FileFeedItemRepository.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/20/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "FileFeedItemRepository.h"
#import "NSFileManager+NSFileManagerCategory.h"

@interface FileFeedItemRepository()
@property (strong, nonatomic) NSFileManager* fileManager;
@end

@implementation FileFeedItemRepository

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fileManager = [NSFileManager defaultManager];
    }
    return self;
}

#pragma mark - FeedItem

- (void)saveFeedItem:(FeedItem*) item toFileWithName:(NSString*) fileName {
    if (item) {
        NSMutableArray* encodedItems = [[NSMutableArray alloc] initWithObjects:[NSKeyedArchiver archivedDataWithRootObject:item], nil];
        
        NSData* encodedArray = [NSKeyedArchiver archivedDataWithRootObject:encodedItems];
        
        NSString* filePath = [NSFileManager pathForFile:fileName];
        
        if ([self.fileManager fileExistsAtPath:filePath]) {
            //load file
            NSMutableArray<FeedItem *>* decodedItems = [self readFeedItemsFile:fileName];
            NSMutableArray<NSData *>* encodedFileContent = [[NSMutableArray alloc] init];
            for (FeedItem* decodedItem in decodedItems) {
                [encodedFileContent addObject:[NSKeyedArchiver archivedDataWithRootObject:decodedItem]];
            }
            
            [encodedFileContent addObject:[NSKeyedArchiver archivedDataWithRootObject:item]];
            NSData* encodedFileData = [NSKeyedArchiver archivedDataWithRootObject:encodedFileContent];
            [encodedFileData writeToFile:filePath atomically:YES];
            
        } else {
            [self.fileManager createFileAtPath:filePath contents:encodedArray attributes:nil];
        }
    }
    
}

- (void) updateFeedItem:(FeedItem *) item inFile:(NSString *) fileName {
    NSMutableArray<FeedItem *>* items = [self readFeedItemsFile:fileName];
    if ([items count] > 1) {
        NSUInteger index = [items indexOfObjectPassingTest:^BOOL(FeedItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [obj.link isEqualToString:item.link];
        }];
        
        [items replaceObjectAtIndex:index withObject:item];
        [self createAndSaveFeedItems:items toFileWithName:fileName];
    }
}

- (NSMutableArray<FeedItem *> *) readFeedItemsFile:(NSString*) fileName {
    NSFileHandle* fileHandle = [NSFileHandle fileHandleForReadingAtPath:[NSFileManager pathForFile:fileName]];
    NSMutableArray<NSData *>* encodedObjects = [NSKeyedUnarchiver unarchiveObjectWithData:[fileHandle readDataToEndOfFile]];
    NSMutableArray<FeedItem *>* decodedItems = [[NSMutableArray alloc] init];
    
    for (NSData* data in encodedObjects) {
        FeedItem* item = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (item) {
            [decodedItems addObject:item];
        }
    }
    return decodedItems;
}

- (void) removeFeedItem:(FeedItem *) item  fromFile:(NSString *) fileName {
    NSMutableArray<FeedItem *>* items = [self readFeedItemsFile:fileName];
    
    for (FeedItem* feedItem in [items copy]) {
        if ([feedItem.link isEqualToString:item.link]) {
            [items removeObject:feedItem];
        }
    }
    
    [self removeAllObjectsFormFile:fileName];
    
    for (FeedItem* fI in [items copy]) {
        [self saveFeedItem:fI toFileWithName:fileName];
    }
}

- (void)createAndSaveFeedItems:(NSMutableArray<FeedItem*>*) items toFileWithName:(NSString*) fileName {
    NSMutableArray<NSData*>* encodedItems = [[NSMutableArray alloc] init];
    
    for (FeedItem* item in [items copy]) {
        if (item) {
            [encodedItems addObject:[NSKeyedArchiver archivedDataWithRootObject:item]];
        }
    }
    
    [self.fileManager createFileAtPath:[NSFileManager pathForFile:fileName] contents:[NSKeyedArchiver archivedDataWithRootObject:encodedItems] attributes:nil];
}

- (void) removeAllObjectsFormFile:(NSString *) fileName {
    [self.fileManager createFileAtPath:[NSFileManager pathForFile:fileName] contents:nil attributes:nil];
}

- (NSMutableArray<NSString *>*) readStringsFromFile:(NSString *) fileName {
    NSFileHandle* fileHandle = [NSFileHandle fileHandleForReadingAtPath:[NSFileManager pathForFile:fileName]];
    NSMutableArray<NSString *>* decodedArray = [NSKeyedUnarchiver unarchiveObjectWithData:[fileHandle readDataToEndOfFile]];
    return decodedArray ? decodedArray : [[NSMutableArray alloc] init];
}

- (void) saveString:(NSString *) stringToSave toFile:(NSString *) fileName {
    NSString* filePath = [NSFileManager pathForFile:fileName];
    
    if ([self.fileManager fileExistsAtPath:filePath]) {
        NSFileHandle* fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
        NSMutableArray<NSString *>* savedItems = [NSKeyedUnarchiver unarchiveObjectWithData:[fileHandle readDataToEndOfFile]];
        if (savedItems) {
            [savedItems addObject:stringToSave];
        } else {
            savedItems = [[NSMutableArray alloc] initWithObjects:stringToSave, nil];
        }
        
        [[NSKeyedArchiver archivedDataWithRootObject:savedItems] writeToFile:filePath atomically:YES];
    } else {
        [self.fileManager createFileAtPath:filePath contents:[NSKeyedArchiver archivedDataWithRootObject:[[NSMutableArray alloc] initWithObjects:stringToSave, nil]] attributes:nil];
    }
}

- (void) removeString:(NSString *) string fromFile:(NSString *) fileName {
    if ([self.fileManager fileExistsAtPath:[NSFileManager pathForFile:fileName]]) {
        NSMutableArray<NSString *>* strings = [self readStringsFromFile:fileName];
        
        for (NSString* str in [strings copy]) {
            if ([str isEqualToString:string]) {
                [strings removeObject:str];
            }
        }
        
        [self removeAllObjectsFormFile:fileName];
        
        for (NSString* str in strings) {
            [self saveString:str toFile:fileName];
        }
        
    }
}

@end
