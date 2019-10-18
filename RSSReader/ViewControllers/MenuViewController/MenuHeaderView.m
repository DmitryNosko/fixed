//
//  MenuHeaderView.m
//  RSSReader
//
//  Created by Dzmitry Noska on 8/30/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "MenuHeaderView.h"
#import "MenuViewControlellerConstants.h"

@implementation MenuHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void) addResource:(id) sender {
    if ([self.listener respondsToSelector:@selector(didTapOnAddResourceButton:)]) {
        [self.listener didTapOnAddResourceButton:self];
    }
}

#pragma mark - HeaderSetUp's

- (void) setUp {
    
    self.addResourceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addResourceButton setTitle:ADD_NEW_RESOURCE_TITLE forState:UIControlStateNormal];
    self.addResourceButton.backgroundColor = [UIColor darkGrayColor];
    self.addResourceButton.titleLabel.numberOfLines = 0;
    [self.addResourceButton addTarget:self action:@selector(addResource:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.addResourceButton];
    
    self.addResourceButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.addResourceButton.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10],
                                              [self.addResourceButton.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10],
                                              [self.addResourceButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10],
                                              [self.addResourceButton.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10]
                                              ]];
}

@end
