//
//  UIButtonWithBlock.h
//  RSSReader
//
//  Created by Dzmitry Noska on 10/7/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^actionBlock)(void);

@interface UIButtonWithBlock : UIButton
- (void) handle:(UIControlEvents) event withBlock:(actionBlock) block;
@end
