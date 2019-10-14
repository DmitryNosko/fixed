//
//  CoreDataFeedItemRepository.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/10/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "CoreDataFeedItemRepository.h"

@implementation CoreDataFeedItemRepository


- (FeedItem *) addFeedItem:(FeedItem *) item {
//    [self.peresistentContainer performBackgroundTask:^(NSManagedObjectContext * context) {
//        context.automaticallyMergesChangesFromParent = YES;
//
//        NSManagedObject* addedItem = [NSEntityDescription insertNewObjectForEntityForName:@"CDFeedItem" inManagedObjectContext:context];
//        [addedItem setValue:[item.identifier UUIDString] forKey:@"identifier"];
//        [addedItem setValue:item.itemTitle forKey:@"itemTitle"];
//        [addedItem setValue:item.link forKey:@"link"];
//        [addedItem setValue:item.pubDate forKey:@"pubDate"];
//        [addedItem setValue:item.itemDescription forKey:@"itemDescription"];
//        [addedItem setValue:item.enclosure forKey:@"enclosure"];
//        [addedItem setValue:item.imageURL forKey:@"imageURL"];
//        [addedItem setValue:[NSNumber numberWithBool:item.isFavorite] forKey:@"isFavorite"];
//        [addedItem setValue:[NSNumber numberWithBool:item.isReadingInProgress] forKey:@"isReadingInProgress"];
//        [addedItem setValue:[NSNumber numberWithBool:item.isReadingComplite] forKey:@"isReadingComplite"];
//        [addedItem setValue:[NSNumber numberWithBool:item.isAvailable] forKey:@"isAvailable"];
//        [addedItem setValue:[item.resourceURL absoluteString] forKey:@"resourceURL"];
//
//        NSManagedObject* resource = [NSEntityDescription insertNewObjectForEntityForName:@"CDFeedResource" inManagedObjectContext:context];
//
//        [addedItem setValue:resource forKey:@"resource"];
//
//        NSError* error = nil;
//
//        if ([context save:&error]) {
//            NSLog(@"Success");
//        } else {
//            NSLog(@"Error = %@", [error localizedDescription]);
//        }
//    }];
    
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
    [newItem setValue:[item.resourceURL absoluteString] forKey:@"resourceURL"];
    
    NSManagedObject* resource = [NSEntityDescription insertNewObjectForEntityForName:@"CDFeedResource" inManagedObjectContext:self.peresistentContainer.viewContext];
    
    [newItem setValue:resource forKey:@"resource"];

    NSError* error = nil;

    if ([self.peresistentContainer.viewContext save:&error]) {
        NSLog(@"Success");
    } else {
        NSLog(@"Error = %@", [error localizedDescription]);
    }
    
    return item;
}

- (NSMutableArray<FeedItem *>*) feedItemsForResource:(NSUUID *) identifier {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"pubDate" ascending:NO]]];
    [request setResultType:NSManagedObjectResultType];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"CDFeedItem" inManagedObjectContext:self.peresistentContainer.viewContext];
    [request setEntity:description];
    [request setPredicate:[NSPredicate predicateWithFormat:@"isReadingComplite = 0"]];
    
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:request error:nil];
    
    NSFetchRequest* request2 = [[NSFetchRequest alloc] init];
    [request2 setResultType:NSManagedObjectResultType];
    NSEntityDescription* description2 = [NSEntityDescription entityForName:@"CDFeedResource" inManagedObjectContext:self.peresistentContainer.viewContext];
    [request2 setEntity:description2];
    [request2 setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", [identifier UUIDString]]];

    NSArray<NSManagedObject *>* requestResult2 = [self.peresistentContainer.viewContext executeFetchRequest:request2 error:nil];
    
    NSMutableArray<FeedItem *>* feedItem = [[NSMutableArray alloc] init];
    
    for (NSManagedObject* obj in requestResult) {
        
        if ([[obj valueForKey:@"resourceURL"] isEqualToString:[[requestResult2 firstObject] valueForKey:@"url"]]) {
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
                                              //resourceURL:[[NSURL alloc] initWithString:[obj valueForKey:@"resourceURL"]]
                                              resourceURL:[obj valueForKey:@"resourceURL"]
                                                 resource:[obj valueForKey:@"resource"]];
            
            [feedItem addObject:item];
            [self.peresistentContainer.viewContext save:nil];
        }
    }
    
    return feedItem;
}

- (NSMutableArray<FeedItem *>*) feedItemsForResources:(NSMutableArray<FeedResource *>*) resources {
    NSMutableArray<FeedItem *>* resultItems = [[NSMutableArray alloc] init];
    
    for (FeedResource* resource in resources) {
        NSFetchRequest* request = [[NSFetchRequest alloc] init];
        [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"pubDate" ascending:NO]]];
        [request setResultType:NSManagedObjectResultType];
        NSEntityDescription* description = [NSEntityDescription entityForName:@"CDFeedItem" inManagedObjectContext:self.peresistentContainer.viewContext];
        [request setEntity:description];
        [request setPredicate:[NSPredicate predicateWithFormat:@"resourceURL == %@ AND isReadingComplite == %@", resource.url, @(NO)]];
        //[request setPredicate:[NSPredicate predicateWithFormat:@"resourceURL == %@", resource.url]];
        
        NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:request error:nil];
        
        for (NSManagedObject* obj in requestResult) {
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
//                                              resourceURL:[[NSURL alloc] initWithString:[obj valueForKey:@"resourceURL"]]
                                              resourceURL:[obj valueForKey:@"resourceURL"]
                                                 resource:resource];
            [resultItems addObject:item];
        }
    }
    
    return resultItems;
}

- (NSMutableArray<FeedItem *>*) allFeedItemsForResources:(NSMutableArray<FeedResource *>*) resources {
    NSMutableArray<FeedItem *>* resultItems = [[NSMutableArray alloc] init];
    
    for (FeedResource* resource in resources) {
        NSMutableArray<FeedItem *>* resourceItems = [self feedItemsForResource:resource.identifier];
        for (FeedItem* item in resourceItems) {
            [resultItems addObject:item];
        }
    }
    
    return resultItems;
}

- (void) updateFeedItem:(FeedItem *) item {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setResultType:NSManagedObjectResultType];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"CDFeedItem" inManagedObjectContext:self.peresistentContainer.viewContext];
    [request setEntity:description];
    [request setPredicate:[NSPredicate predicateWithFormat:@"link == %@", item.link]];
    
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:request error:nil];
    
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
    [self.peresistentContainer.viewContext save:nil];
}

- (void) removeFeedItem:(FeedItem *) item {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setResultType:NSManagedObjectResultType];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"CDFeedItem" inManagedObjectContext:self.peresistentContainer.viewContext];
    [request setEntity:description];
    [request setPredicate:[NSPredicate predicateWithFormat:@"link == %@", item.link]];
    
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
    
    NSManagedObjectID* stID = [[requestResult firstObject] objectID];
    if (stID) {
        id obj = [self.peresistentContainer.viewContext existingObjectWithID:stID error:nil];
        [self.peresistentContainer.viewContext deleteObject:obj];
        [self.peresistentContainer.viewContext save:nil];
    }
    
}

- (void) removeFeedItemForResource:(NSUUID *) identifier {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setResultType:NSManagedObjectResultType];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"CDFeedItem" inManagedObjectContext:self.peresistentContainer.viewContext];
    [request setEntity:description];
    //[request setPredicate:[NSPredicate predicateWithFormat:@"resource.identifier == %@", [identifier UUIDString]]];
    
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:request error:nil];
    
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
    
    for (NSManagedObject* obj in requestResult) {
        FeedResource* res =(FeedResource*)[obj valueForKey:@"resource"];
        
        if ([[res.identifier UUIDString] isEqualToString:[identifier UUIDString]]) {
            NSManagedObjectID* stID = [obj objectID];
            id obj = [self.peresistentContainer.viewContext existingObjectWithID:stID error:nil];
            [self.peresistentContainer.viewContext deleteObject:obj];
            [self.peresistentContainer.viewContext save:nil];
        }
    }
}

- (void) removeAllFeedItems {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setResultType:NSManagedObjectResultType];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"CDFeedItem" inManagedObjectContext:self.peresistentContainer.viewContext];
    [request setEntity:description];
    
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:request error:nil];
    
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
    
    for (NSManagedObject* obj in requestResult) {
        NSManagedObjectID* stID = [obj objectID];
        id obj = [self.peresistentContainer.viewContext existingObjectWithID:stID error:nil];
        [self.peresistentContainer.viewContext deleteObject:obj];
        [self.peresistentContainer.viewContext save:nil];
    }
}

- (NSMutableArray<FeedItem *>*) favoriteFeedItems:(NSMutableArray<FeedResource *>*) resources {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setResultType:NSManagedObjectResultType];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"CDFeedItem" inManagedObjectContext:self.peresistentContainer.viewContext];
    [request setEntity:description];
    [request setPredicate:[NSPredicate predicateWithFormat:@"isFavorite == %@", @(YES)]];
    
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:request error:nil];
    NSMutableArray<FeedItem *>* favoriteItems = [[NSMutableArray alloc] init];
    
    for (NSManagedObject* obj in requestResult) {
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
//                                          resourceURL:[[NSURL alloc] initWithString:[obj valueForKey:@"resourceURL"]]
                                          resourceURL:[obj valueForKey:@"resourceURL"]
                                             resource:[obj valueForKey:@"resource"]];
        
        [favoriteItems addObject:item];
    }
    
    return favoriteItems;
}

- (NSMutableArray<NSString *>*) favoriteFeedItemLinks:(NSMutableArray<FeedResource *>*) resources {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setResultType:NSManagedObjectResultType];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"CDFeedItem" inManagedObjectContext:self.peresistentContainer.viewContext];
    [request setEntity:description];
    [request setPredicate:[NSPredicate predicateWithFormat:@"isFavorite == %@", @(YES)]];
    
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:request error:nil];
    NSMutableArray<NSString *>* favoriteItemLinks = [[NSMutableArray alloc] init];
    
    for (NSManagedObject* obj in requestResult) {
        [favoriteItemLinks addObject:[obj valueForKey:@"link"]];
    }
    
    return favoriteItemLinks;
}

- (NSMutableArray<NSString *>*) readingInProgressFeedItemLinks:(NSMutableArray<FeedResource *>*) resources {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setResultType:NSManagedObjectResultType];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"CDFeedItem" inManagedObjectContext:self.peresistentContainer.viewContext];
    [request setEntity:description];
    [request setPredicate:[NSPredicate predicateWithFormat:@"isReadingInProgress == %@", @(YES)]];
    
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:request error:nil];
    NSMutableArray<NSString *>* readingInProgressFeedItemLinks = [[NSMutableArray alloc] init];
    
    for (NSManagedObject* obj in requestResult) {
        [readingInProgressFeedItemLinks addObject:[obj valueForKey:@"link"]];
    }
    
    return readingInProgressFeedItemLinks;
}

- (NSMutableArray<NSString *>*) readingCompliteFeedItemLinks:(NSMutableArray<FeedResource *>*) resources {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setResultType:NSManagedObjectResultType];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"CDFeedItem" inManagedObjectContext:self.peresistentContainer.viewContext];
    [request setEntity:description];
    [request setPredicate:[NSPredicate predicateWithFormat:@"isReadingComplite == %@", @(YES)]];
    
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:request error:nil];
    NSMutableArray<NSString *>* readingInProgressFeedItemLinks = [[NSMutableArray alloc] init];
    
    for (NSManagedObject* obj in requestResult) {
        [readingInProgressFeedItemLinks addObject:[obj valueForKey:@"link"]];
    }
    
    return readingInProgressFeedItemLinks;
}

@end
