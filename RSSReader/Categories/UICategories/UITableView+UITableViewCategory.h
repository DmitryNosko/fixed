//
//  UITableView+UITableViewCategory.h
//  RSSReader
//
//  Created by Dzmitry Noska on 10/7/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UITableView (UITableViewCategory)
+ (UITableView *) tableVeiwWithFrame:(CGRect) rect  style:(NSInteger) style cellClass:(Class) cellClass cellIdentifier:(NSString *) cellIdentifier parentView:(UIView *) parentView delegateAndDataSource:(id) delegateAndDataSource;
@end

