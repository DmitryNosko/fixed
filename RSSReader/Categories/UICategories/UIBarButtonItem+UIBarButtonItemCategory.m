//
//  UIBarButtonItem+UIBarButtonItemCategory.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/7/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "UIBarButtonItem+UIBarButtonItemCategory.h"
#import "UIButtonWithBlock.h"

@implementation UIBarButtonItem (UIBarButtonItemCategory)
+ (UIBarButtonItem *_Nonnull) barButtonItemWithTitle:(NSString *_Nullable) title image:(UIImage *_Nullable) image block:(void(^_Nonnull)(void)) block {
    UIButtonWithBlock* button = [UIButtonWithBlock buttonWithType:UIButtonTypeCustom];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [button setImage:image forState:UIControlStateNormal];
    }
    
    [button setTintColor:[UIColor whiteColor]];
    [button handle:UIControlEventTouchUpInside withBlock:block];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
@end
