//
//  UIAlertController+UIAlertControllerCategory.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/7/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "UIAlertController+UIAlertControllerCategory.h"

static NSString* const CANCEL_BUTTON_TITLE = @"Cancel";
static NSString* const ADD_BUTTON_TITLE = @"Add";

@implementation UIAlertController (UIAlertControllerCategory)

+ (UIAlertController *_Nonnull) alertControllerWithTitle:(NSString *_Nonnull) title message:(NSString *_Nonnull) message firstTextFieldTitle:(NSString *_Nullable) firstTitle secondTextFieldTitle:(NSString *_Nullable) secondTitle hasCloseButton:(BOOL) closeButton andBlock:(void(^_Nullable)(UIAlertAction* _Nullable)) block {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    if (firstTitle) {
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = firstTitle;
        }];
    }
    if (secondTitle) {
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = secondTitle;
        }];
    }
    if (closeButton) {
        [alert addAction:[UIAlertAction actionWithTitle:CANCEL_BUTTON_TITLE style:UIAlertActionStyleCancel handler:nil]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:ADD_BUTTON_TITLE style:UIAlertActionStyleDefault handler:block]];
    return alert;
}
@end
