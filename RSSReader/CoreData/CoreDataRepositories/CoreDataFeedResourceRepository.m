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
//    [self.peresistentContainer performBackgroundTask:^(NSManagedObjectContext * context) {
//        NSManagedObject* newResource = [NSEntityDescription insertNewObjectForEntityForName:@"CDFeedResource" inManagedObjectContext:context];
//        [newResource setValue:[resource.identifier UUIDString] forKey:@"identifier"];
//        [newResource setValue:resource.name forKey:@"name"];
//        [newResource setValue:[resource.url absoluteString] forKey:@"url"];//absoulute
//
//        NSError* error = nil;
//
//        if ([context save:&error]) {
//            NSLog(@"Success");
//        } else {
//            NSLog(@"Error = %@", [error localizedDescription]);
//        }
//    }];
    
//    NSFetchRequest* request = [[NSFetchRequest alloc] init];
//    [request setResultType:NSManagedObjectResultType];
//    NSEntityDescription* description = [NSEntityDescription entityForName:@"CDFeedResource" inManagedObjectContext:self.peresistentContainer.viewContext];
//    [request setEntity:description];
//    [request setPredicate:[NSPredicate predicateWithFormat:@"url == %@", resource.url]];
    
    //NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:request error:nil];
    
        NSManagedObject* newResource = [NSEntityDescription insertNewObjectForEntityForName:@"CDFeedResource" inManagedObjectContext:self.peresistentContainer.viewContext];
        
            [newResource setValue:[resource.identifier UUIDString] forKey:@"identifier"];
            [newResource setValue:resource.name forKey:@"name"];
            [newResource setValue:[resource.url absoluteString] forKey:@"url"];
            
            NSError* error = nil;
            
            if ([self.peresistentContainer.viewContext save:&error]) {
                NSLog(@"Success");
            } else {
                NSLog(@"Error = %@", [error localizedDescription]);
            }

    return resource;
}

- (void) removeFeedResource:(FeedResource *) resource {
    NSFetchRequest* resourcesRequest = [NSFetchRequest fetchRequestwithEntity:@"CDFeedResource" context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", [resource.identifier UUIDString]]];
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:resourcesRequest error:nil];
    
//    [self.peresistentContainer performBackgroundTask:^(NSManagedObjectContext * context) {
//            NSManagedObjectID* stID = [[requestResult firstObject] objectID];
//            id obj = [context existingObjectWithID:stID error:nil];
//            [context deleteObject:obj];
//            [context save:nil];
//    }];
    
    for (NSManagedObject* obj in [requestResult copy]) {
        NSManagedObjectID* stID = [obj objectID];
        id obj = [self.peresistentContainer.viewContext existingObjectWithID:stID error:nil];
        [self.peresistentContainer.viewContext deleteObject:obj];
    }
    
    [self saveContext:self.peresistentContainer.viewContext];
}

- (NSMutableArray<FeedResource *>*) feedResources {
    NSFetchRequest* request = [NSFetchRequest fetchRequestwithEntity:@"CDFeedResource" context:self.peresistentContainer.viewContext andPredicate:nil];
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:request error:nil];
    
    NSMutableArray<FeedResource *>* feedResources = [[NSMutableArray alloc] init];
    for (NSManagedObject* obj in [requestResult copy]) {
        FeedResource* resource = [[FeedResource alloc] initWithID:[[NSUUID alloc] initWithUUIDString:[obj valueForKey:@"identifier"]] name:[obj valueForKey:@"name"] url:[NSURL URLWithString:[obj valueForKey:@"url"]]];
        if (resource != nil) {
            [feedResources addObject:resource];
        }
    }
    
    return feedResources;
}

- (FeedResource *) resourceByURL:(NSURL *) url {
    NSFetchRequest* request = [NSFetchRequest fetchRequestwithEntity:@"CDFeedResource" context:self.peresistentContainer.viewContext andPredicate:[NSPredicate predicateWithFormat:@"url == %@", url]];
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:request error:nil];
    
    FeedResource* resource = nil;
    if ([requestResult count] != 0) {
        NSManagedObject* obj = [requestResult firstObject];
        resource = [[FeedResource alloc] initWithID:[[NSUUID alloc] initWithUUIDString:[obj valueForKey:@"identifier"]] name:[obj valueForKey:@"name"] url:[NSURL URLWithString:[obj valueForKey:@"url"]]];
        return resource;
    }
    
    return resource;
}

@end
