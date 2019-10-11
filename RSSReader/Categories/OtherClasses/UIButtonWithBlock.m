//
//  UIButtonWithBlock.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/7/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "UIButtonWithBlock.h"

@interface UIButtonWithBlock()
@property (copy, nonatomic) actionBlock block;
@end

@implementation UIButtonWithBlock

- (void)handle:(UIControlEvents)event withBlock:(actionBlock)block {
    self.block = block;
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}

- (void) callActionBlock:(id) sender {
    if (self.block) {
        self.block();
    }
}

@end
