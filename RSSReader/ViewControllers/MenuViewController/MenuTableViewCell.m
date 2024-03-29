//
//  MenuTableViewCell.m
//  RSSReader
//
//  Created by Dzmitry Noska on 8/29/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "UILabel+UILabelCategory.h"
#import "MenuViewControlellerConstants.h"

@implementation MenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void) pushToCheckBoxButton:(id)sender {
    if ([self.listener respondsToSelector:@selector(didTapOnCheckBoxButton:)]) {
        [self.listener didTapOnCheckBoxButton:self];
    }
}

#pragma mark - CellSetIp's

- (void) setUp {
    self.backgroundColor = [UIColor clearColor];
    
    self.newsLabel = [UILabel labelWithText:nil andFontSize:18 parentView:self.contentView textColor:[UIColor whiteColor] textAligment:NSTextAlignmentCenter];
    [NSLayoutConstraint activateConstraints:@[
                                              [self.newsLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10],
                                              [self.newsLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:50],
                                              [self.newsLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10]
                                              ]];
    
    self.checkBoxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.checkBoxButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.checkBoxButton.layer.cornerRadius = 5.f;
    self.checkBoxButton.clipsToBounds = YES;
    self.checkBoxButton.backgroundColor = [UIColor clearColor];
    [self.checkBoxButton setImage:[UIImage imageNamed:EMPTY_BOX_BUTTON_IMAGE] forState:UIControlStateNormal];
    [self.checkBoxButton  setImage:[UIImage imageNamed:FULL_BOX_BUTTON_IMAGE] forState:UIControlStateSelected];
    [self.checkBoxButton addTarget:self action:@selector(pushToCheckBoxButton:) forControlEvents:UIControlEventTouchUpInside];
    self.checkBoxButton.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.checkBoxButton];
    
    self.checkBoxButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.checkBoxButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10],
                                              [self.checkBoxButton.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
                                              [self.checkBoxButton.heightAnchor constraintEqualToConstant:20],
                                              [self.checkBoxButton.widthAnchor constraintEqualToConstant:20]
                                              ]];
}

@end
