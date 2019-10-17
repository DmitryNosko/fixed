//
//  NSFetchRequest+NSFetchRequestCategory.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/17/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "NSFetchRequest+NSFetchRequestCategory.h"

@implementation NSFetchRequest (NSFetchRequestCategory)

+ (NSFetchRequest * _Nonnull) fetchRequestwithEntity:(NSString * _Nonnull) entity context:(NSManagedObjectContext * _Nonnull) context andPredicate:(NSPredicate * _Nullable) predicate {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setResultType:NSManagedObjectResultType];
    NSEntityDescription* description = [NSEntityDescription entityForName:entity inManagedObjectContext:context];
    [request setEntity:description];
    if (predicate) {
        [request setPredicate:predicate];
    }
    return request;
}

@end
