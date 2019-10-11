//
//  DetailsViewController.m
//  RSSReader
//
//  Created by Dzmitry Noska on 8/27/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "DetailsViewController.h"
#import "UILabel+UILabelCategory.h"
#import "DetailsViewControllerConstants.h"
#import "UIBarButtonItem+UIBarButtonItemCategory.h"

@interface DetailsViewController ()
@property (strong, nonatomic) UIScrollView* scrollView;
@property (strong, nonatomic) UILabel* itemTitel;
@property (strong, nonatomic) UIImageView* itemImage;
@property (strong, nonatomic) UILabel* itemDescription;
@property (strong, nonatomic) UILabel* itemDate;
@property (strong, nonatomic) NSData* imageData;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUp];
    [self configurateNavigationItem];
    
    if (![self.itemURLString isEqualToString:@""]) {
        NSThread* thread = [[NSThread alloc] initWithBlock:^{
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:self.itemURLString]];
            if (imageData) {
                self.imageData = imageData;
                [self performSelectorOnMainThread:@selector(execute) withObject:nil waitUntilDone:NO];
            }
        }];
        [thread start];
    }
}

- (void) execute {
    self.itemImage.image = [UIImage imageWithData:self.imageData];
}

- (void) setUp {
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
                                              [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
                                              [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                              [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
                                              ]];
    
    
    self.itemTitel = [UILabel labelWithText:[NSString stringWithFormat:@"News: %@", self.itemTitleString] andFontSize:16 parentView:self.scrollView textColor:[UIColor blackColor] textAligment:NSTextAlignmentCenter];
    [NSLayoutConstraint activateConstraints:@[
                                              [self.itemTitel.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor constant:10],
                                              [self.itemTitel.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:10],
                                              [self.itemTitel.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor constant:-10],
                                              [self.itemTitel.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor]
                                              ]];
    
    if (self.hasInternetConnection) {
        
        
        self.itemImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NO_PHOTO_IMAGE]];
        [self.scrollView addSubview:self.itemImage];
        
        self.itemImage.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.itemImage.topAnchor constraintEqualToAnchor:self.itemTitel.bottomAnchor constant:15],
                                                  [self.itemImage.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:10],
                                                  [self.itemImage.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor constant:-10],
                                                  [self.itemImage.heightAnchor constraintEqualToConstant:CGRectGetWidth(self.view.bounds)],
                                                  [self.itemImage.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor]
                                                  ]];
        
        
        self.itemDate = [UILabel labelWithText:[NSString stringWithFormat:@"Publication date: %@", self.itemDateString] andFontSize:12 parentView:self.scrollView textColor:[UIColor blackColor] textAligment:NSTextAlignmentCenter];
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.itemDate.topAnchor constraintEqualToAnchor:self.itemImage.bottomAnchor constant:5],
                                                  [self.itemDate.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:10],
                                                  [self.itemDate.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor constant:-10],
                                                  [self.itemDate.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor]
                                                  ]];
        
        
        self.itemDescription = [UILabel labelWithText:[NSString stringWithFormat:@"Description: %@", self.itemDescriptionString] andFontSize:16 parentView:self.scrollView textColor:[UIColor blackColor] textAligment:NSTextAlignmentCenter];
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.itemDescription.topAnchor constraintEqualToAnchor:self.itemDate.bottomAnchor constant:50],
                                                  [self.itemDescription.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:10],
                                                  [self.itemDescription.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor constant:-10],
                                                  [self.itemDescription.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor],
                                                  [self.itemDescription.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor]
                                                  ]];
    } else {
        self.itemDescription = [UILabel labelWithText:[NSString stringWithFormat:@"Description: %@", self.itemDescriptionString] andFontSize:16 parentView:self.scrollView textColor:[UIColor blackColor] textAligment:NSTextAlignmentCenter];
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.itemDescription.topAnchor constraintEqualToAnchor:self.itemTitel.bottomAnchor constant:30],
                                                  [self.itemDescription.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:10],
                                                  [self.itemDescription.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor constant:-10],
                                                  [self.itemDescription.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor]
                                                  ]];
    }
    
}

- (void) configurateNavigationItem {
    __weak DetailsViewController* weakSelf = self;
    self.navigationItem.title = TITLE_NAME;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:DVC_BACK_BUTTON_TITLE image:nil block:^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    }];
}

@end
