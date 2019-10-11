//
//  UILabel+UILabelCategory.h
//  RSSReader
//
//  Created by Dzmitry Noska on 10/7/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (UILabelCategory)
+ (UILabel *) labelWithText:(NSString *) text andFontSize:(double) size parentView:(UIView *) view textColor:(UIColor *) color textAligment:(NSInteger) aligment;
@end

