//
//  CoreDataFeedItemRepository.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/10/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "CoreDataFeedItemRepository.h"
#import "NSFetchRequest+NSFetchRequestCategory.h"
#import "FeedItemConstants.h"
#import "FeedResourceConstants.h"

@implementation CoreDataFeedItemRepository

- (FeedItem *) addFeedItem:(FeedItem *) item {
    NSFetchRequest* request = [NSFetchRequest fetchRequestwithEntity:RESOURCE_CORE_DATA_NAME context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", [item.resource.identifier UUIDString]]];
    NSArray<NSManagedObject *>* resource = [self.peresistentContainer.viewContext executeFetchRequest:request error:nil];
    
    NSManagedObject* newItem = [NSEntityDescription insertNewObjectForEntityForName:ITEM_CORE_DATA_NAME inManagedObjectContext:self.peresistentContainer.viewContext];
    [newItem setValue:[item.identifier UUIDString] forKey:ITEM_ID_KEY];
    [newItem setValue:item.itemTitle forKey:ITEM_TITLE_KEY];
    [newItem setValue:item.link forKey:ITEM_LINK_KEY];
    [newItem setValue:item.pubDate forKey:ITEM_PUBDATE_KEY];
    [newItem setValue:item.itemDescription forKey:ITEM_DESCRIPTION_KEY];
    [newItem setValue:item.enclosure forKey:ITEM_ENCLOSURE_KEY];
    [newItem setValue:item.imageURL forKey:ITEM_IMAGE_URL_KEY];
    [newItem setValue:[NSNumber numberWithBool:item.isFavorite] forKey:ITEM_IS_FAVORITE_KEY];
    [newItem setValue:[NSNumber numberWithBool:item.isReadingInProgress] forKey:ITEM_IS_READING_IN_PROGRESS_KEY];
    [newItem setValue:[NSNumber numberWithBool:item.isReadingComplite] forKey:ITEM_IS_READING_COMPLITE_KEY];
    [newItem setValue:[NSNumber numberWithBool:item.isAvailable] forKey:ITEM_IS_AVAILABLE_KEY];
    if ([item.resourceURL isKindOfClass:[NSString class]]) {
        [newItem setValue:item.resourceURL forKey:RESOURCE_URL_NAME_KEY];
    } else {
        [newItem setValue:[item.resourceURL absoluteString] forKey:RESOURCE_URL_NAME_KEY];
    }
    [newItem setValue:[resource firstObject] forKey:ITEM_FEED_RESOURCE_KEY];

    [self saveContext:self.peresistentContainer.viewContext];
    
    return item;
}

- (NSMutableArray<FeedItem *>*) feedItemsForResource:(NSUUID *) identifier {
    NSFetchRequest* resourceRequest = [NSFetchRequest fetchRequestwithEntity:RESOURCE_CORE_DATA_NAME context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", [identifier UUIDString]]];
    NSManagedObject* resourceObject = [[self.peresistentContainer.viewContext executeFetchRequest:resourceRequest error:nil] firstObject];
    
    NSFetchRequest* itemsRequest = [NSFetchRequest fetchRequestwithEntity:ITEM_CORE_DATA_NAME context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"isReadingComplite = 0 AND resource.identifier == %@", [resourceObject valueForKey:ITEM_ID_KEY]]];
    NSMutableArray<FeedItem *>* resourceItems = [[NSMutableArray alloc] init];
    
    for (NSManagedObject* obj in [[self.peresistentContainer.viewContext executeFetchRequest:itemsRequest error:nil] copy]) {
        
            FeedResource* resource = [[FeedResource alloc] initWithID:[[NSUUID alloc] initWithUUIDString:[resourceObject valueForKey:RESOURCE_ID_KEY]] name:[resourceObject valueForKey:RESOURCE_NAME_KEY] url:[NSURL URLWithString:[resourceObject valueForKey:RESOURCE_URL_KEY]]];
            
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

- (NSMutableArray<FeedItem *>*) feedItemsForResources:(NSMutableArray<FeedResource *>*) resources {
    NSMutableArray<FeedItem *>* resourcesItems = [[NSMutableArray alloc] init];
    for (FeedResource* resource in [resources copy]) {
        
        NSFetchRequest* itemsRequest = [NSFetchRequest fetchRequestwithEntity:ITEM_CORE_DATA_NAME context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"resourceURL == %@ AND isReadingComplite == %@", resource.url, @(NO)]];
        
        NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:itemsRequest error:nil];
        
        for (NSManagedObject* obj in [requestResult copy]) {
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
                [resourcesItems addObject:item];
            }
        }
    }
    
    return resourcesItems;
}

- (NSMutableArray<FeedItem *>*) allFeedItemsForResources:(NSMutableArray<FeedResource *>*) resources {
    NSMutableArray<FeedItem *>* resultItems = [[NSMutableArray alloc] init];
    for (FeedResource* resource in [resources copy]) {
        NSMutableArray<FeedItem *>* resourceItems = [self feedItemsForResource:resource.identifier];
        for (FeedItem* item in [resourceItems copy]) {
            if (item) {
                [resultItems addObject:item];
            }
        }
    }
    
    return resultItems;
}

- (void) updateFeedItem:(FeedItem *) item {
    NSFetchRequest* itemsRequest = [NSFetchRequest fetchRequestwithEntity:ITEM_CORE_DATA_NAME context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", item.identifier]];
//    [self.peresistentContainer performBackgroundTask:^(NSManagedObjectContext * context) {
//        NSManagedObject* itemToUpdate = [requestResult firstObject];
//        [itemToUpdate setValue:[NSNumber numberWithBool:item.isFavorite] forKey:@"isFavorite"];
//        [itemToUpdate setValue:[NSNumber numberWithBool:item.isReadingInProgress] forKey:@"isReadingInProgress"];
//        [itemToUpdate setValue:[NSNumber numberWithBool:item.isReadingComplite] forKey:@"isReadingComplite"];
//        [itemToUpdate setValue:[NSNumber numberWithBool:item.isAvailable] forKey:@"isAvailable"];
//        NSError* error = nil;
//        if (![context save:&error]) {
//            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//            abort();
//        }
//    }];
    NSManagedObject* itemToUpdate = [[self.peresistentContainer.viewContext executeFetchRequest:itemsRequest error:nil] firstObject];
    [itemToUpdate setValue:[NSNumber numberWithBool:item.isFavorite] forKey:ITEM_IS_FAVORITE_KEY];
    [itemToUpdate setValue:[NSNumber numberWithBool:item.isReadingInProgress] forKey:ITEM_IS_READING_IN_PROGRESS_KEY];
    [itemToUpdate setValue:[NSNumber numberWithBool:item.isReadingComplite] forKey:ITEM_IS_READING_COMPLITE_KEY];
    [itemToUpdate setValue:[NSNumber numberWithBool:item.isAvailable] forKey:ITEM_IS_AVAILABLE_KEY];
    
    [self saveContext:self.peresistentContainer.viewContext];
}

- (void) removeFeedItem:(FeedItem *) item {
    NSFetchRequest* request = [NSFetchRequest fetchRequestwithEntity:ITEM_CORE_DATA_NAME context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", item.identifier]];
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:request error:nil];
//    [self.peresistentContainer performBackgroundTask:^(NSManagedObjectContext * context) {
//        NSManagedObjectID* stID = [[requestResult firstObject] objectID];
//        id obj = [context existingObjectWithID:stID error:nil];
//        [context deleteObject:obj];
//        NSError* error = nil;
//        if (![context save:&error]) {
//            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//            abort();
//        }
//    }];
    for (NSManagedObject* object in [requestResult copy]) {
        NSManagedObjectID* stID = [object objectID];
        if (stID) {
            id obj = [self.peresistentContainer.viewContext existingObjectWithID:stID error:nil];
            [self.peresistentContainer.viewContext deleteObject:obj];
            [self saveContext:self.peresistentContainer.viewContext];
        }
    }
}

- (void) removeFeedItemForResource:(NSUUID *) identifier {
    
    NSFetchRequest* itemsRequest = [NSFetchRequest fetchRequestwithEntity:ITEM_CORE_DATA_NAME context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"resource.identifier == %@", [identifier UUIDString]]];
    [self deleteAllObjectsFromResultRquest:[self.peresistentContainer.viewContext executeFetchRequest:itemsRequest error:nil] andContext:self.peresistentContainer.viewContext];
//    [self.peresistentContainer performBackgroundTask:^(NSManagedObjectContext * context) {
//        for (NSManagedObject* obj in requestResult) {
//            NSManagedObjectID* stID = [obj objectID];
//            id obj = [context existingObjectWithID:stID error:nil];
//            [context deleteObject:obj];
//            NSError* error = nil;
//            if (![context save:&error]) {
//                NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//                abort();
//            }
//        }
//    }];
    
//    for (NSManagedObject* obj in [requestResult copy]) {
//        [self.peresistentContainer.viewContext deleteObject:obj];
//
////        NSManagedObjectID* stID = [obj objectID];
////        if (stID) {
////            id object = [self.context existingObjectWithID:stID error:nil];
////            [self.peresistentContainer.viewContext deleteObject:object];
////            [self.peresistentContainer.viewContext save:nil];
//////            NSLog(@"deleted = %@", [self.peresistentContainer.viewContext deletedObjects]);
////        }
//    }
//    [self saveContext:self.peresistentContainer.viewContext];
}

- (void) removeAllFeedItems {
    NSFetchRequest* itemsRequest = [NSFetchRequest fetchRequestwithEntity:ITEM_CORE_DATA_NAME context:self.peresistentContainer.viewContext andPredicate:nil];
    [self deleteAllObjectsFromResultRquest:[self.peresistentContainer.viewContext executeFetchRequest:itemsRequest error:nil] andContext:self.peresistentContainer.viewContext];
//    [self.peresistentContainer performBackgroundTask:^(NSManagedObjectContext * context) {
//        for (NSManagedObject* obj in requestResult) {
//            NSManagedObjectID* stID = [obj objectID];
//            id obj = [context existingObjectWithID:stID error:nil];
//            [context deleteObject:obj];
//            NSError* error = nil;
//            if (![context save:&error]) {
//                NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//                abort();
//            }
//        }
//    }];
}

- (NSMutableArray<FeedItem *>*) favoriteFeedItems:(NSMutableArray<FeedResource *>*) resources {
    NSFetchRequest* itemsRequest = [NSFetchRequest fetchRequestwithEntity:ITEM_CORE_DATA_NAME context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"isFavorite == %@", @(YES)]];
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:itemsRequest error:nil];
    
    NSMutableArray<FeedItem *>* favoriteItems = [[NSMutableArray alloc] init];
    for (NSManagedObject* obj in [requestResult copy]) {
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
                                             resource:[obj valueForKey:ITEM_FEED_RESOURCE_KEY]];
        if (item) {
            [favoriteItems addObject:item];
        }
    }
    return favoriteItems;
}

- (NSMutableArray<NSString *>*) favoriteFeedItemLinks:(NSMutableArray<FeedResource *>*) resources {
    NSFetchRequest* itemsRequest = [NSFetchRequest fetchRequestwithEntity:ITEM_CORE_DATA_NAME context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"isFavorite == %@", @(YES)]];
    return [self feedItemsFrom:itemsRequest];
}

- (NSMutableArray<NSString *>*) readingInProgressFeedItemLinks:(NSMutableArray<FeedResource *>*) resources {

    NSFetchRequest* itemsRequest = [NSFetchRequest fetchRequestwithEntity:ITEM_CORE_DATA_NAME context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"isReadingInProgress == %@", @(YES)]];
    return [self feedItemsFrom:itemsRequest];
}

- (NSMutableArray<NSString *>*) readingCompliteFeedItemLinks:(NSMutableArray<FeedResource *>*) resources {
    NSFetchRequest* itemsRequest = [NSFetchRequest fetchRequestwithEntity:ITEM_CORE_DATA_NAME context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"isReadingComplite == %@", @(YES)]];
    return [self feedItemsFrom:itemsRequest];
}

- (NSMutableArray<NSString *> *) feedItemsFrom:(NSFetchRequest *) request {
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:request error:nil];
    NSMutableArray<NSString *>* validItems = [[NSMutableArray alloc] init];
    for (NSManagedObject* obj in [requestResult copy]) {
        if ([obj valueForKey:ITEM_LINK_KEY]) {
            [validItems addObject:[obj valueForKey:ITEM_LINK_KEY]];
        }
    }
    return validItems;
}

@end
