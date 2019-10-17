//
//  NSFetchRequest+NSFetchRequestCategory.h
//  RSSReader
//
//  Created by Dzmitry Noska on 10/17/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSFetchRequest (NSFetchRequestCategory)
+ (NSFetchRequest * _Nonnull) fetchRequestwithEntity:(NSString * _Nonnull) entity context:(NSManagedObjectContext * _Nonnull) context andPredicate:(NSPredicate * _Nullable) predicate;
@end

