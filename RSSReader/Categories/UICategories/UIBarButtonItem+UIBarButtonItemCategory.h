//
//  UIBarButtonItem+UIBarButtonItemCategory.h
//  RSSReader
//
//  Created by Dzmitry Noska on 10/7/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (UIBarButtonItemCategory)
+ (UIBarButtonItem *_Nonnull) barButtonItemWithTitle:(NSString *_Nullable) title image:(UIImage *_Nullable) image block:(void(^_Nonnull)(void)) block;
@end

