//
//  UISegmentedControl+UISegmentedControlCategory.h
//  RSSReader
//
//  Created by Dzmitry Noska on 10/7/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISegmentedControl (UISegmentedControlCategory)
+ (UISegmentedControl *) controlWithItems:(NSArray *) items parentView:(UIView *) parentView target:(id) target action:(SEL) action;
@end

