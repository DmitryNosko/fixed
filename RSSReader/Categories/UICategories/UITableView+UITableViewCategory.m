//
//  UITableView+UITableViewCategory.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/7/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "UITableView+UITableViewCategory.h"

@implementation UITableView (UITableViewCategory)
+ (UITableView *) tableVeiwWithFrame:(CGRect) rect  style:(NSInteger) style cellClass:(Class) cellClass cellIdentifier:(NSString *) cellIdentifier parentView:(UIView *) parentView delegateAndDataSource:(id) delegateAndDataSource {
    UITableView* tableView = [[UITableView alloc] initWithFrame:rect style:style];
    [tableView registerClass:cellClass forCellReuseIdentifier:cellIdentifier];
    tableView.delegate = delegateAndDataSource;
    tableView.dataSource = delegateAndDataSource;
    tableView.tableFooterView = [UIView new];
    [parentView addSubview:tableView];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    return tableView;
}
@end
