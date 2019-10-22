//
//  FileManager.m
//  RSSReader
//
//  Created by USER on 10/20/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fileManager = [NSFileManager defaultManager];
    }
    return self;
}

@end

