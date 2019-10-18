//
//  CoreDataControlelr.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/10/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "CoreDataController.h"
#import "NSFileManager+NSFileManagerCategory.h"

@implementation CoreDataController
@synthesize peresistentContainer = _peresistentContainer;

- (instancetype)init
{
    self = [super init];
    if (self) {
        //[self peresistentContainer];
    }
    return self;
}

- (NSPersistentContainer *) peresistentContainer {

    @synchronized (self) {
        if (_peresistentContainer == nil) {
            _peresistentContainer = [[NSPersistentContainer alloc] initWithName:@"RSSReader"];
            NSURL* url = [[NSFileManager applicationDocumentDirectory] URLByAppendingPathComponent:@"RSSReader.sqlite"];
            _peresistentContainer.persistentStoreDescriptions = @[[NSPersistentStoreDescription persistentStoreDescriptionWithURL:url]];
            
            [_peresistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * storeDescription, NSError * error) {
                if (error != nil) {
                    NSLog(@"Unresolved error peresistentContainer %@, %@", error, error.userInfo);
                    //abort();
                }
            }];
        }
    }

    return _peresistentContainer;
}

- (void) saveContext:(NSManagedObjectContext *) context {
    NSError* error = nil;
    if ([context save:&error]) {
        NSLog(@"Success with context = %@", context);
    } else {
        NSLog(@"Error = %@", [error localizedDescription]);
    }
}

- (NSArray<NSManagedObject *> *)executeFetchRequest:(NSFetchRequest *) request withContext:(NSManagedObjectContext *) context {
    return [context executeFetchRequest:request error:nil];
}

- (void) deleteAllObjectsFromResultRquest:(NSArray<NSManagedObject *> *)result andContext:(NSManagedObjectContext *)context {
    for (NSManagedObject* object in [result copy]) {
        NSManagedObjectID* stID = [object objectID];
        if (stID) {
            id obj = [context existingObjectWithID:stID error:nil];
            if (obj) {
                [context deleteObject:obj];
            }
        }
    }
    [self saveContext:context];
}

@end
