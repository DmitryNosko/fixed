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
    NSArray<NSManagedObject *>* resultRequest = [self.peresistentContainer.viewContext executeFetchRequest:itemsRequest error:nil];
    
    return [self resourceItemsFromRequest:resultRequest resource:resourceObject];;
}

- (NSMutableArray<FeedItem *>*) feedItemsForResources:(NSMutableArray<FeedResource *>*) resources {
    NSMutableArray<FeedItem *>* resourcesItems = [[NSMutableArray alloc] init];
    for (FeedResource* resource in [resources copy]) {
        
        NSFetchRequest* itemsRequest = [NSFetchRequest fetchRequestwithEntity:ITEM_CORE_DATA_NAME context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"resourceURL == %@ AND isReadingComplite == %@", resource.url, @(NO)]];
        
        NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:itemsRequest error:nil];
        
        [resourcesItems addObjectsFromArray:[self resourceItemsFromRequest:requestResult resource:nil]];
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
    [self deleteAllObjectsFromResultRquest:requestResult andContext:self.peresistentContainer.viewContext];
}

- (void) removeFeedItemForResource:(NSUUID *) identifier {
    NSFetchRequest* itemsRequest = [NSFetchRequest fetchRequestwithEntity:ITEM_CORE_DATA_NAME context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"resource.identifier == %@", [identifier UUIDString]]];
    [self deleteAllObjectsFromResultRquest:[self.peresistentContainer.viewContext executeFetchRequest:itemsRequest error:nil] andContext:self.peresistentContainer.viewContext];
}

- (void) removeAllFeedItems {
    NSFetchRequest* itemsRequest = [NSFetchRequest fetchRequestwithEntity:ITEM_CORE_DATA_NAME context:self.peresistentContainer.viewContext andPredicate:nil];
    [self deleteAllObjectsFromResultRquest:[self.peresistentContainer.viewContext executeFetchRequest:itemsRequest error:nil] andContext:self.peresistentContainer.viewContext];
}

- (NSMutableArray<FeedItem *>*) favoriteFeedItems:(NSMutableArray<FeedResource *>*) resources {
    NSFetchRequest* itemsRequest = [NSFetchRequest fetchRequestwithEntity:ITEM_CORE_DATA_NAME context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"isFavorite == %@", @(YES)]];
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:itemsRequest error:nil];
    return [self resourceItemsFromRequest:requestResult resource:nil];
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
