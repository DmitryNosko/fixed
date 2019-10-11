//
//  UILabel+UILabelCategory.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/7/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "UILabel+UILabelCategory.h"

@implementation UILabel (UILabelCategory)
+ (UILabel *) labelWithText:(NSString *) text andFontSize:(double) size parentView:(UIView *) view textColor:(UIColor *) color textAligment:(NSInteger) aligment {
    UILabel* label = [[UILabel alloc] init];
    label.textAlignment = aligment;
    label.numberOfLines = 0;
    label.text = text;
    label.textColor = color;
    [label setFont:[UIFont fontWithName:@"Helvetica" size:size]];
    [view addSubview:label];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}
@end
