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
#import "FeedItemBuilderService.h"

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
        FeedItem* item = [[[[[[[[[[[[[[[[FeedItemBuilderService alloc] init]
                             buildIdentifier:[[NSUUID alloc] initWithUUIDString:[obj valueForKey:ITEM_ID_KEY]]]
                            buildItemTitle:[obj valueForKey:ITEM_TITLE_KEY]]
                           buildLink:[obj valueForKey:ITEM_LINK_KEY]]
                          buildPubDate:[obj valueForKey:ITEM_PUBDATE_KEY]]
                         buildItemDescription:[obj valueForKey:ITEM_DESCRIPTION_KEY]]
                        buildEnclosure:[obj valueForKey:ITEM_ENCLOSURE_KEY]]
                       buildImageURL:[obj valueForKey:ITEM_IMAGE_URL_KEY]]
                      buildIsFavorite:[[obj valueForKey:ITEM_IS_FAVORITE_KEY] boolValue]]
                     buildIsReadingInProgress:[[obj valueForKey:ITEM_IS_READING_IN_PROGRESS_KEY] boolValue]]
                    buildIsReadingComplite:[[obj valueForKey:ITEM_IS_READING_COMPLITE_KEY] boolValue]]
                   buildIsAvailable:[[obj valueForKey:ITEM_IS_AVAILABLE_KEY] boolValue]]
                  buildResourceURL:[obj valueForKey:ITEM_FEED_RESOURCE_URL_KEY]]
                 buildResource:resource]
                buildFeedItem];
        
        if (item) {
            [resourceItems addObject:item];
        }
    }
    
    return resourceItems;
}

@end
