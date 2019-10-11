//
//  UIVisualEffectView+UIVisualEffectViewCategory.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/7/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "UIVisualEffectView+UIVisualEffectViewCategory.h"

@implementation UIVisualEffectView (UIVisualEffectViewCategory)
+ (UIVisualEffectView *) viewWithBlurEffect:(UIBlurEffect *) effect parentView:(UIView *) view cornerRadius:(CGFloat) radius {
    UIVisualEffectView* effectView = [[UIVisualEffectView alloc] init];
    effectView.layer.cornerRadius = 20;
    effectView.clipsToBounds = YES;
    effectView.hidden = YES;
    effectView.effect = effect;
    [view addSubview:effectView];
    return effectView;
}
@end
