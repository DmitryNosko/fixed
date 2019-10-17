//
//  CoreDataControlelr.h
//  RSSReader
//
//  Created by Dzmitry Noska on 10/10/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataController : NSObject
@property (strong, nonatomic, readonly) NSPersistentContainer* peresistentContainer;
- (void) saveContext:(NSManagedObjectContext *) context;
@end

