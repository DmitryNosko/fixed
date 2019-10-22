//
//  CoreDataFeedResourceRepository.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/10/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "CoreDataFeedResourceRepository.h"
#import "NSFetchRequest+NSFetchRequestCategory.h"

@implementation CoreDataFeedResourceRepository

- (FeedResource *) addFeedResource:(FeedResource *) resource {
    NSManagedObject* newResource = [NSEntityDescription insertNewObjectForEntityForName:RESOURCE_CORE_DATA_NAME inManagedObjectContext:self.peresistentContainer.viewContext];
    [newResource setValue:[resource.identifier UUIDString] forKey:RESOURCE_ID_KEY];
    [newResource setValue:resource.name forKey:RESOURCE_NAME_KEY];
    [newResource setValue:[resource.url absoluteString] forKey:RESOURCE_URL_KEY];
    [self saveContext:self.peresistentContainer.viewContext];
    return resource;
}

- (void) removeFeedResource:(FeedResource *) resource {
    NSFetchRequest* resourcesRequest = [NSFetchRequest fetchRequestwithEntity:RESOURCE_CORE_DATA_NAME context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", [resource.identifier UUIDString]]];
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:resourcesRequest error:nil];
    [self deleteAllObjectsFromResultRquest:requestResult andContext:self.peresistentContainer.viewContext];
}

- (NSMutableArray<FeedResource *>*) feedResources {
    NSFetchRequest* request = [NSFetchRequest fetchRequestwithEntity:RESOURCE_CORE_DATA_NAME context:self.peresistentContainer.viewContext andPredicate:nil];
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:request error:nil];
    
    NSMutableArray<FeedResource *>* feedResources = [[NSMutableArray alloc] init];
    for (NSManagedObject* obj in [requestResult copy]) {
        FeedResource* resource = [[FeedResource alloc] initWithID:[[NSUUID alloc] initWithUUIDString:[obj valueForKey:RESOURCE_ID_KEY]] name:[obj valueForKey:RESOURCE_NAME_KEY] url:[NSURL URLWithString:[obj valueForKey:RESOURCE_URL_KEY]]];
        if (resource != nil) {
            [feedResources addObject:resource];
        }
    }
    
    return feedResources;
}

- (FeedResource *) resourceByURL:(NSURL *) url {
    NSFetchRequest* request = [NSFetchRequest fetchRequestwithEntity:RESOURCE_CORE_DATA_NAME context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"url == %@", url]];
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:request error:nil];
    
    FeedResource* resource = nil;
    if ([requestResult count] != 0) {
        NSManagedObject* obj = [requestResult firstObject];
        resource = [[FeedResource alloc] initWithID:[[NSUUID alloc] initWithUUIDString:[obj valueForKey:RESOURCE_ID_KEY]] name:[obj valueForKey:RESOURCE_NAME_KEY] url:[NSURL URLWithString:[obj valueForKey:RESOURCE_URL_KEY]]];
        return resource;
    }
    
    return resource;
}

@end
