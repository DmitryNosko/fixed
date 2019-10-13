//
//  UISegmentedControl+UISegmentedControlCategory.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/7/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "UISegmentedControl+UISegmentedControlCategory.h"

@implementation UISegmentedControl (UISegmentedControlCategory)

+ (UISegmentedControl *) controlWithItems:(NSArray *) items parentView:(UIView *) parentView target:(id) target action:(SEL) action;{
    UISegmentedControl* segmentControl = [[UISegmentedControl alloc] initWithItems:items];
    //[[UILabel appearanceWhenContainedIn:[UISegmentedControl class], nil] setNumberOfLines:0];
    [segmentControl addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    segmentControl.tintColor = [UIColor whiteColor];
    [parentView addSubview:segmentControl];
    return segmentControl;
}

@end
