//
//  CoreDataFeedResourceRepository.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/10/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "CoreDataFeedResourceRepository.h"

@implementation CoreDataFeedResourceRepository

- (FeedResource *) addFeedResource:(FeedResource *) resource {
    [self.peresistentContainer performBackgroundTask:^(NSManagedObjectContext * context) {
        NSManagedObject* newResource = [NSEntityDescription insertNewObjectForEntityForName:@"CDFeedResource" inManagedObjectContext:self.peresistentContainer.viewContext];
        [newResource setValue:resource.identifier forKey:@"identifier"];
        [newResource setValue:resource.name forKey:@"name"];
        [newResource setValue:resource.url forKey:@"url"];
       
        NSError* error = nil;
        
        if ([context save:&error]) {
            NSLog(@"Success");
        } else {
            NSLog(@"Error = %@", [error localizedDescription]);
        }
    }];
    return resource;
}

- (void) removeFeedResource:(FeedResource *) resource {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setResultType:NSManagedObjectResultType];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"CDFeedResource" inManagedObjectContext:self.peresistentContainer.viewContext];
    [request setEntity:description];
    [request setPredicate:[NSPredicate predicateWithFormat:@"url == %@", [resource.url absoluteString]]];
    
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:request error:nil];
    
    [self.peresistentContainer performBackgroundTask:^(NSManagedObjectContext * context) {
            NSManagedObjectID* stID = [[requestResult firstObject] objectID];
            id obj = [context existingObjectWithID:stID error:nil];
            [context deleteObject:obj];
            [context save:nil];
    }];
}

- (NSMutableArray<FeedResource *>*) feedResources {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setResultType:NSManagedObjectResultType];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"CDFeedResource" inManagedObjectContext:self.peresistentContainer.viewContext];
    [request setEntity:description];
    
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:request error:nil];
    NSMutableArray<FeedResource *>* feedResources = [[NSMutableArray alloc] init];
    
    for (NSManagedObject* obj in requestResult) {
        FeedResource* resource = [[FeedResource alloc] initWithID:[[NSUUID alloc] initWithUUIDString:[obj valueForKey:@"identifier"]] name:[obj valueForKey:@"name"] url:[obj valueForKey:@"url"]];
        [feedResources addObject:resource];
    }
    
    return feedResources;
}

- (FeedResource *) resourceByURL:(NSURL *) url {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setResultType:NSManagedObjectResultType];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"CDFeedResource" inManagedObjectContext:self.peresistentContainer.viewContext];
    [request setEntity:description];
    [request setPredicate:[NSPredicate predicateWithFormat:@"url == %@", [url absoluteString]]];
    
    NSArray<NSManagedObject *>* requestResult = [self.peresistentContainer.viewContext executeFetchRequest:request error:nil];
    
    if (requestResult) {
        NSManagedObject* obj = [requestResult objectAtIndex:0];
        return [[FeedResource alloc] initWithID:[[NSUUID alloc] initWithUUIDString:[obj valueForKey:@"identifier"]] name:[obj valueForKey:@"name"] url:[obj valueForKey:@"url"]];
    }
    
    return nil;
}

@end
