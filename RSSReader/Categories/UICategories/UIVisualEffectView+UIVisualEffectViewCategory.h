//
//  UIVisualEffectView+UIVisualEffectViewCategory.h
//  RSSReader
//
//  Created by Dzmitry Noska on 10/7/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIVisualEffectView (UIVisualEffectViewCategory)
+ (UIVisualEffectView *) viewWithBlurEffect:(UIBlurEffect *) effect parentView:(UIView *) view cornerRadius:(CGFloat) radius;
@end

