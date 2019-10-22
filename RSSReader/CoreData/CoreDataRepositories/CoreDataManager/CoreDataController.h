//
//  CoreDataControlelr.h
//  RSSReader
//
//  Created by Dzmitry Noska on 10/10/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FeedItem.h"
#import "FeedResourceConstants.h"
#import "FeedItemConstants.h"

@interface CoreDataController : NSObject

@property (strong, nonatomic, readonly) NSPersistentContainer* peresistentContainer;
- (void) saveContext:(NSManagedObjectContext *) context;
- (NSArray<NSManagedObject *>*) executeFetchRequest:(NSFetchRequest *) request withContext:(NSManagedObjectContext *) context;
- (void) deleteAllObjectsFromResultRquest:(NSArray<NSManagedObject *>*) result andContext:(NSManagedObjectContext *) context;
- (NSMutableArray<FeedItem *> * _Nonnull) resourceItemsFromRequest:(NSArray<NSManagedObject *>* _Nonnull) request resource:(NSManagedObject * _Nullable) resourceObject;

@end

