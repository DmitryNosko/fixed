//
//  UIAlertController+UIAlertControllerCategory.h
//  RSSReader
//
//  Created by Dzmitry Noska on 10/7/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (UIAlertControllerCategory)
+ (UIAlertController *_Nonnull) alertControllerWithTitle:(NSString *_Nonnull) title message:(NSString *_Nonnull) message firstTextFieldTitle:(NSString *_Nullable) firstTitle secondTextFieldTitle:(NSString *_Nullable) secondTitle hasCloseButton:(BOOL) closeButton andBlock:(void(^_Nullable)(UIAlertAction* _Nullable)) block;
@end

