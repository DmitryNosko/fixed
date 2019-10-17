//
//  CoreDataFeedItemRepository.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/10/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "CoreDataFeedItemRepository.h"
#import "NSFetchRequest+NSFetchRequestCategory.h"

@implementation CoreDataFeedItemRepository

- (FeedItem *) addFeedItem:(FeedItem *) item {
    
    NSManagedObject* newItem = [NSEntityDescription insertNewObjectForEntityForName:@"CDFeedItem" inManagedObjectContext:self.peresistentContainer.viewContext];
    [newItem setValue:[item.identifier UUIDString] forKey:@"identifier"];
    [newItem setValue:item.itemTitle forKey:@"itemTitle"];
    [newItem setValue:item.link forKey:@"link"];
    [newItem setValue:item.pubDate forKey:@"pubDate"];
    [newItem setValue:item.itemDescription forKey:@"itemDescription"];
    [newItem setValue:item.enclosure forKey:@"enclosure"];
    [newItem setValue:item.imageURL forKey:@"imageURL"];
    [newItem setValue:[NSNumber numberWithBool:item.isFavorite] forKey:@"isFavorite"];
    [newItem setValue:[NSNumber numberWithBool:item.isReadingInProgress] forKey:@"isReadingInProgress"];
    [newItem setValue:[NSNumber numberWithBool:item.isReadingComplite] forKey:@"isReadingComplite"];
    [newItem setValue:[NSNumber numberWithBool:item.isAvailable] forKey:@"isAvailable"];
    
    if ([item.resourceURL isKindOfClass:[NSString class]]) {
        [newItem setValue:item.resourceURL forKey:@"resourceURL"];
    } else {
        [newItem setValue:[item.resourceURL absoluteString] forKey:@"resourceURL"];
    }
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestwithEntity:@"CDFeedResource" context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", [item.resource.identifier UUIDString]]];

    NSArray<NSManagedObject *>* resource = [self.peresistentContainer.viewContext executeFetchRequest:request error:nil];
    [newItem setValue:[resource firstObject] forKey:@"resource"];

    [self saveContext:self.peresistentContainer.viewContext];
    
    return item;
}

- (NSMutableArray<FeedItem *>*) feedItemsForResource:(NSUUID *) identifier {
    NSFetchRequest* resourceRequest = [NSFetchRequest fetchRequestwithEntity:@"CDFeedResource" context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", [identifier UUIDString]]];
    NSManagedObject* resourceObject = [[self.peresistentContainer.viewContext executeFetchRequest:resourceRequest error:nil] firstObject];
    
    NSFetchRequest* itemsRequest = [NSFetchRequest fetchRequestwithEntity:@"CDFeedItem" context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"isReadingComplite = 0 AND resource.identifier == %@", [resourceObject valueForKey:@"identifier"]]];
    
    NSMutableArray<FeedItem *>* resourceItems = [[NSMutableArray alloc] init];
    
    for (NSManagedObject* obj in [[self.peresistentContainer.viewContext executeFetchRequest:itemsRequest error:nil] copy]) {
        
            FeedResource* resource = [[FeedResource alloc] initWithID:[[NSUUID alloc] initWithUUIDString:[resourceObject valueForKey:@"identifier"]] name:[resourceObject valueForKey:@"name"] url:[NSURL URLWithString:[resourceObject valueForKey:@"url"]]];
            
            FeedItem* item = [[FeedItem alloc] initWithID:[[NSUUID alloc] initWithUUIDString:[obj valueForKey:@"identifier"]]
                                                    itemTitle:[obj valueForKey:@"itemTitle"]
                                                         link:[obj valueForKey:@"link"]
                                                      pubDate:[obj valueForKey:@"pubDate"]
                                              itemDescription:[obj valueForKey:@"itemDescription"]
                                                    enclosure:[obj valueForKey:@"enclosure"]
                                                     imageURL:[obj valueForKey:@"imageURL"]
                                                   isFavorite:[[obj valueForKey:@"isFavorite"] boolValue]
                                          isReadingInProgress:[[obj valueForKey:@"isReadingInProgress"] boolValue]
                                            isReadingComplite:[[obj valueForKey:@"isReadingComplite"] boolValue]
                                                  isAvailable:[[obj valueForKey:@"isAvailable"] boolValue]
                                                  resourceURL:[obj valueForKey:@"resourceURL"]
                                                     resource:resource];
        if (item) {
            [resourceItems addObject:item];
            [self saveContext:self.peresistentContainer.viewContext];
        }
    }
    
    return resourceItems;
}

- (NSMutableArray<FeedItem *>*) feedItemsForResources:(NSMutableArray<FeedResource *>*) resources {
    NSMutableArray<FeedItem *>* resourcesItems = [[NSMutableArray alloc] init];
    for (FeedResource* resource in [resources copy]) {
        
        NSFetchRequest* itemsRequest = [NSFetchRequest fetchRequestwithEntity:@"CDFeedItem" context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"resourceURL == %@ AND isReadingComplite == %@", resource.url, @(NO)]];
        
        NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:itemsRequest error:nil];
        
        for (NSManagedObject* obj in [requestResult copy]) {
                    FeedItem* item = [[FeedItem alloc] initWithID:[[NSUUID alloc] initWithUUIDString:[obj valueForKey:@"identifier"]]
                                                        itemTitle:[obj valueForKey:@"itemTitle"]
                                                             link:[obj valueForKey:@"link"]
                                                          pubDate:[obj valueForKey:@"pubDate"]
                                                  itemDescription:[obj valueForKey:@"itemDescription"]
                                                        enclosure:[obj valueForKey:@"enclosure"]
                                                         imageURL:[obj valueForKey:@"imageURL"]
                                                       isFavorite:[[obj valueForKey:@"isFavorite"] boolValue]
                                              isReadingInProgress:[[obj valueForKey:@"isReadingInProgress"] boolValue]
                                                isReadingComplite:[[obj valueForKey:@"isReadingComplite"] boolValue]
                                                      isAvailable:[[obj valueForKey:@"isAvailable"] boolValue]
                                                      resourceURL:[obj valueForKey:@"resourceURL"]
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
    NSFetchRequest* itemsRequest = [NSFetchRequest fetchRequestwithEntity:@"CDFeedItem" context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", item.identifier]];
    
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:itemsRequest error:nil];
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
    NSManagedObject* itemToUpdate = [requestResult firstObject];
    [itemToUpdate setValue:[NSNumber numberWithBool:item.isFavorite] forKey:@"isFavorite"];
    [itemToUpdate setValue:[NSNumber numberWithBool:item.isReadingInProgress] forKey:@"isReadingInProgress"];
    [itemToUpdate setValue:[NSNumber numberWithBool:item.isReadingComplite] forKey:@"isReadingComplite"];
    [itemToUpdate setValue:[NSNumber numberWithBool:item.isAvailable] forKey:@"isAvailable"];
    
    [self saveContext:self.peresistentContainer.viewContext];
}

- (void) removeFeedItem:(FeedItem *) item {
    NSFetchRequest* request = [NSFetchRequest fetchRequestwithEntity:@"CDFeedItem" context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", item.identifier]];
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
    
    NSFetchRequest* itemsRequest = [NSFetchRequest fetchRequestwithEntity:@"CDFeedItem" context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"resource.identifier == %@", [identifier UUIDString]]];
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:itemsRequest error:nil];
    
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
    
    for (NSManagedObject* obj in [requestResult copy]) {
        [self.peresistentContainer.viewContext deleteObject:obj];
        
//        NSManagedObjectID* stID = [obj objectID];
//        if (stID) {
//            id object = [self.context existingObjectWithID:stID error:nil];
//            [self.peresistentContainer.viewContext deleteObject:object];
//            [self.peresistentContainer.viewContext save:nil];
////            NSLog(@"deleted = %@", [self.peresistentContainer.viewContext deletedObjects]);
//        }
    }
    [self saveContext:self.peresistentContainer.viewContext];
}

- (void) removeAllFeedItems {
    NSFetchRequest* itemsRequest = [NSFetchRequest fetchRequestwithEntity:@"CDFeedItem" context:self.peresistentContainer.viewContext andPredicate:nil];
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:itemsRequest error:nil];
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
    for (NSManagedObject* object in [requestResult copy]) {
        NSManagedObjectID* stID = [object objectID];
        if (stID) {
            id obj = [self.peresistentContainer.viewContext existingObjectWithID:stID error:nil];
            [self.peresistentContainer.viewContext deleteObject:obj];
        }
    }
    [self saveContext:self.peresistentContainer.viewContext];
}

- (NSMutableArray<FeedItem *>*) favoriteFeedItems:(NSMutableArray<FeedResource *>*) resources {
    NSFetchRequest* itemsRequest = [NSFetchRequest fetchRequestwithEntity:@"CDFeedItem" context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"isFavorite == %@", @(YES)]];
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:itemsRequest error:nil];
    
    NSMutableArray<FeedItem *>* favoriteItems = [[NSMutableArray alloc] init];
    for (NSManagedObject* obj in [requestResult copy]) {
        FeedItem* item = [[FeedItem alloc] initWithID:[[NSUUID alloc] initWithUUIDString:[obj valueForKey:@"identifier"]]
                                            itemTitle:[obj valueForKey:@"itemTitle"]
                                                 link:[obj valueForKey:@"link"]
                                              pubDate:[obj valueForKey:@"pubDate"]
                                      itemDescription:[obj valueForKey:@"itemDescription"]
                                            enclosure:[obj valueForKey:@"enclosure"]
                                             imageURL:[obj valueForKey:@"imageURL"]
                                           isFavorite:[[obj valueForKey:@"isFavorite"] boolValue]
                                  isReadingInProgress:[[obj valueForKey:@"isReadingInProgress"] boolValue]
                                    isReadingComplite:[[obj valueForKey:@"isReadingComplite"] boolValue]
                                          isAvailable:[[obj valueForKey:@"isAvailable"] boolValue]
                                          resourceURL:[obj valueForKey:@"resourceURL"]
                                             resource:[obj valueForKey:@"resource"]];
        if (item) {
            [favoriteItems addObject:item];
        }
    }
    return favoriteItems;
}

- (NSMutableArray<NSString *>*) favoriteFeedItemLinks:(NSMutableArray<FeedResource *>*) resources {
    
    NSFetchRequest* itemsRequest = [NSFetchRequest fetchRequestwithEntity:@"CDFeedItem" context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"isFavorite == %@", @(YES)]];
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:itemsRequest error:nil];
    return [self feedItemsFrom:requestResult];
}

- (NSMutableArray<NSString *>*) readingInProgressFeedItemLinks:(NSMutableArray<FeedResource *>*) resources {

    NSFetchRequest* itemsRequest = [NSFetchRequest fetchRequestwithEntity:@"CDFeedItem" context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"isReadingInProgress == %@", @(YES)]];
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:itemsRequest error:nil];
    return [self feedItemsFrom:requestResult];
}



- (NSMutableArray<NSString *>*) readingCompliteFeedItemLinks:(NSMutableArray<FeedResource *>*) resources {
    NSFetchRequest* itemsRequest = [NSFetchRequest fetchRequestwithEntity:@"CDFeedItem" context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"isReadingComplite == %@", @(YES)]];
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:itemsRequest error:nil];
    return [self feedItemsFrom:requestResult];
}

- (NSMutableArray<NSString *> *) feedItemsFrom:(NSArray<NSManagedObject *> *) request {
    NSMutableArray<NSString *>* validItems = [[NSMutableArray alloc] init];
    for (NSManagedObject* obj in [request copy]) {
        if ([obj valueForKey:@"link"]) {
            [validItems addObject:[obj valueForKey:@"link"]];
        }
    }
    return validItems;
}

@end
