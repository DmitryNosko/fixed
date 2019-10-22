//
//  CoreDataControlelr.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/10/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "CoreDataController.h"
#import "NSFileManager+NSFileManagerCategory.h"
#import "CoreDataContacts.h"

@implementation CoreDataController
@synthesize peresistentContainer = _peresistentContainer;

- (NSPersistentContainer *) peresistentContainer {

    @synchronized (self) {
        if (_peresistentContainer == nil) {
            _peresistentContainer = [[NSPersistentContainer alloc] initWithName:PERSISTENT_CONTAINER_NAME];
            NSURL* url = [[NSFileManager applicationDocumentDirectory] URLByAppendingPathComponent:CORE_DATA_PATH];
            _peresistentContainer.persistentStoreDescriptions = @[[NSPersistentStoreDescription persistentStoreDescriptionWithURL:url]];
            [_peresistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * storeDescription, NSError * error) {
                if (error != nil) {
                    NSLog(@"Unresolved error peresistentContainer %@, %@", error, error.userInfo);
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
            [context deleteObject:obj];
        }
    }
    [self saveContext:context];
}

- (NSMutableArray<FeedItem *> * _Nonnull) resourceItemsFromRequest:(NSArray<NSManagedObject *>* _Nonnull) request resource:(NSManagedObject * _Nullable) resourceObject {
    NSMutableArray<FeedItem *>* resourceItems = [[NSMutableArray alloc] init];
    
    for (NSManagedObject* obj in request) {
        FeedResource* resource = nil;
        
        if (resourceObject) {
            resource = [[FeedResource alloc] initWithID:[[NSUUID alloc] initWithUUIDString:[resourceObject valueForKey:RESOURCE_ID_KEY]] name:[resourceObject valueForKey:RESOURCE_NAME_KEY] url:[NSURL URLWithString:[resourceObject valueForKey:RESOURCE_URL_KEY]]];
        }
        
        FeedItem* item = [[FeedItem alloc] initWithID:[[NSUUID alloc] initWithUUIDString:[obj valueForKey:ITEM_ID_KEY]]
                                            itemTitle:[obj valueForKey:ITEM_TITLE_KEY]
                                                 link:[obj valueForKey:ITEM_LINK_KEY]
                                              pubDate:[obj valueForKey:ITEM_PUBDATE_KEY]
                                      itemDescription:[obj valueForKey:ITEM_DESCRIPTION_KEY]
                                            enclosure:[obj valueForKey:ITEM_ENCLOSURE_KEY]
                                             imageURL:[obj valueForKey:ITEM_IMAGE_URL_KEY]
                                           isFavorite:[[obj valueForKey:ITEM_IS_FAVORITE_KEY] boolValue]
                                  isReadingInProgress:[[obj valueForKey:ITEM_IS_READING_IN_PROGRESS_KEY] boolValue]
                                    isReadingComplite:[[obj valueForKey:ITEM_IS_READING_COMPLITE_KEY] boolValue]
                                          isAvailable:[[obj valueForKey:ITEM_IS_AVAILABLE_KEY] boolValue]
                                          resourceURL:[obj valueForKey:ITEM_FEED_RESOURCE_URL_KEY]
                                             resource:resource];
        if (item) {
            [resourceItems addObject:item];
        }
    }
    
    return resourceItems;
}

@end
