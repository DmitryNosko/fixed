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
        [self peresistentContainer];
    }
    return self;
}

- (NSPersistentContainer *) peresistentContainer {
    __weak CoreDataController* weakSelf = self;
    @synchronized (self) {
        if (_peresistentContainer == nil) {
            _peresistentContainer = [[NSPersistentContainer alloc] initWithName:@"RSSReader"];
            NSURL* url = [[NSFileManager applicationDocumentDirectory] URLByAppendingPathComponent:@"RSSReader.sqlite"];
            //NSLog(@"url = %@", url);
            _peresistentContainer.persistentStoreDescriptions = @[[NSPersistentStoreDescription persistentStoreDescriptionWithURL:url]];
            
            [_peresistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * storeDescription, NSError * error) {
                if (error != nil) {
                    NSLog(@"Unresolved error peresistentContainer %@, %@", error, error.userInfo);
                    //abort();
                }
                weakSelf.peresistentContainer.viewContext.automaticallyMergesChangesFromParent = YES;
            }];
        }
    }

    return _peresistentContainer;
}

- (void) saveContext {
    NSManagedObjectContext* context = self.peresistentContainer.viewContext;
    NSError* error = nil;
    if ([context hasChanges] && [context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
