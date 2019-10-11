//
//  MenuViewController.m
//  RSSReader
//
//  Created by Dzmitry Noska on 8/29/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"
#import "MenuHeaderView.h"
#import "RSSURLValidator.h"
#import "FeedResource.h"
#import "MainViewController.h"
#import "Reachability+ReachabilityCategory.h"
#import "FeedResourceServiceFactory.h"
#import "UIAlertController+UIAlertControllerCategory.h"
#import "InternetConnectionConstants.h"
#import "UITableView+UITableViewCategory.h"
#import "MenuViewControlellerConstants.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate, MenuHeaderViewListener, MenuTableViewCellListener>
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray<FeedResource *>* feedsResources;
@property (strong, nonatomic) RSSURLValidator* urlValidator;
@property (strong, nonatomic) NSMutableArray<NSIndexPath *>* selectedCheckBoxes;
@property (strong, nonatomic) FeedResourceServiceFactory* feedResourceServiceFactory;
@property (strong, nonatomic) NSNumber* dataSourceStrategyID;
@property (strong, nonatomic) UIAlertController* addFeedAlert;
@end

@implementation MenuViewController

- (void)loadView {
    [super loadView];
    NSLog(@"loadView");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataSourceStrategyID = [NSUserDefaults.standardUserDefaults objectForKey:MVC_DATA_SOURCE_STRATEGY_ID];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(storageWasChangedNotificationFirst:)
                                                     name:MainViewControllerStorageWasChangedNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    [self tableViewSetUp];
    self.urlValidator = [[RSSURLValidator alloc] init];
    self.selectedCheckBoxes = [[NSMutableArray alloc] init];
    self.feedResourceServiceFactory = [[[FeedResourceServiceFactory alloc] initWithStorageValue:self.dataSourceStrategyID] feedResourceServiceProtocol];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storageWasChangedNotification:)
                                                 name:MainViewControllerStorageWasChangedNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSMutableArray<FeedResource *>* savedFeedResources = [self.feedResourceServiceFactory feedResources];
    if ([savedFeedResources count] == 0) {
        FeedResource* defaultResource = [[FeedResource alloc] initWithID:[NSUUID UUID] name:MVC_DEFAULT_RESOURCE_NAME url:[NSURL URLWithString:MVC_DEFAULT_URL_TO_PARSE]];
        [self.feedResourceServiceFactory addFeedResource:defaultResource];
        self.feedsResources = [[NSMutableArray alloc] initWithObjects:defaultResource, nil];
    } else {
        self.feedsResources = savedFeedResources;
    }
}

- (void) tableViewSetUp {
    self.tableView = [UITableView tableVeiwWithFrame:CGRectZero style:UITableViewStyleGrouped cellClass:[MenuTableViewCell class] cellIdentifier:MVC_CELL_IDENTIFIER parentView:self.view delegateAndDataSource:self];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.rowHeight = 90;
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    [self.tableView registerClass:[MenuHeaderView class] forHeaderFooterViewReuseIdentifier:HEADER_IDENTIFIER];
    [NSLayoutConstraint activateConstraints:@[
                                              [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
                                              [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-140],
                                              [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor]
                                              ]];
    
    self.fetchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fetchButton setTitle:FETCH_BUTTON_TITLE forState:UIControlStateNormal];
    [self.fetchButton addTarget:self action:@selector(pushToFetchButton:) forControlEvents:UIControlEventTouchUpInside];
    self.fetchButton.backgroundColor = [UIColor lightGrayColor];
    self.fetchButton.hidden = YES;
    [self.view addSubview:self.fetchButton];
    
    self.fetchButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.fetchButton.trailingAnchor constraintEqualToAnchor:self.tableView.trailingAnchor constant:-20],
                                              [self.fetchButton.leadingAnchor constraintEqualToAnchor:self.tableView.leadingAnchor constant:20],
                                              [self.fetchButton.centerXAnchor constraintEqualToAnchor:self.tableView.centerXAnchor],
                                              [self.fetchButton.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-20]
                                              ]];
    
    [NSLayoutConstraint activateConstraints:@[
                                              [self.tableView.bottomAnchor constraintEqualToAnchor:self.fetchButton.topAnchor]
                                              ]];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.feedsResources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:MVC_CELL_IDENTIFIER forIndexPath:indexPath];
    cell.listener = self;
    cell.newsLabel.text = self.feedsResources[indexPath.row].name;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MenuHeaderView* menuHeader = (MenuHeaderView*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:HEADER_IDENTIFIER];
    menuHeader.listener = self;
    return menuHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 130;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FeedResource* resource = [self.feedsResources objectAtIndex:indexPath.row];
    self.feedResourceWasChosenHandler(resource);
}

- (void)didTapOnAddResourceButton:(MenuHeaderView *)addResourceButton {
    
    __weak MenuViewController* weakSelf = self;
    if ([Reachability hasInternerConnection]) {
        self.addFeedAlert = [UIAlertController alertControllerWithTitle:ADD_STUDENT_ALERT_TITLE message:ADD_STUDENT_ALERT_MESSAGE firstTextFieldTitle:FIRST_TEXT_FIELD_TITLE_KEY secondTextFieldTitle:SECOND_TEXT_FIELD_TITLE_KEY hasCloseButton:YES andBlock:^(UIAlertAction *block) {
            
            NSArray<UITextField*>* textField = weakSelf.addFeedAlert.textFields;
            UITextField* feedTextField = [textField firstObject];
            UITextField* urlTextField = [textField lastObject];
            
            if (![feedTextField.text isEqualToString:MVC_EMPTY_STRING] && ![urlTextField.text isEqualToString:MVC_EMPTY_STRING]) {
                
                NSString* inputString = urlTextField.text;
                NSURL* urlForParse = [weakSelf.urlValidator parseFeedResoursecFromURL:[NSURL URLWithString:inputString]];
                if (urlForParse) {
                    FeedResource* resource = [weakSelf.feedResourceServiceFactory addFeedResource:[[FeedResource alloc] initWithID:[NSUUID UUID] name:feedTextField.text url:urlForParse]];
                    weakSelf.feedsResources = [weakSelf.feedResourceServiceFactory feedResources];
                    [weakSelf.tableView reloadData];
                    weakSelf.feedResourceWasAddedHandler(resource);
                } else {
                    NSLog(@"exeption");
                }
            }
        }];
        [self presentViewController:weakSelf.addFeedAlert animated:YES completion:nil];
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:INTERNET_CONNECTION_ALERT_TITLE message:INTERNET_CONNECTION_MESSAGE firstTextFieldTitle:nil secondTextFieldTitle:nil hasCloseButton:NO andBlock:nil];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        FeedResource* resource = [self.feedsResources objectAtIndex:indexPath.row];
        [self.feedResourceServiceFactory removeFeedResource:resource];
        [self.feedsResources removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        [self.tableView reloadData];
    }
}

- (void) choseResources:(id) sender {
    [self.tableView setEditing:sender animated:YES];
}

#pragma mark - MenuTableViewListener

- (void)didTapOnCheckBoxButton:(MenuTableViewCell *)checkBoxButton {
    
    checkBoxButton.checkBoxButton.selected = !checkBoxButton.checkBoxButton.selected;
    NSIndexPath* indexPath = [self.tableView indexPathForCell:checkBoxButton];
    
    if (checkBoxButton.checkBoxButton.selected) {
        self.fetchButton.hidden = NO;
        
        [self.selectedCheckBoxes addObject:indexPath];
    } else {
        [self.selectedCheckBoxes removeObject:indexPath];
        if (self.selectedCheckBoxes.count == 0) {
            self.fetchButton.hidden = YES;
        }
    }
}

- (void) pushToFetchButton:(id) sender {
    NSMutableArray<FeedResource *>* resourcesToLoad = [[NSMutableArray alloc] init];
    
    for (NSIndexPath* ip in [self.selectedCheckBoxes copy]) {
        [resourcesToLoad addObject:[self.feedsResources objectAtIndex:ip.row]];
    }
    self.fetchButtonWasPressedHandler(resourcesToLoad);
}

#pragma mark - NSNotification

- (void) storageWasChangedNotification:(NSNotification *) notification {
    NSNumber* newStorageValue = [notification.userInfo objectForKey:@"MainViewControllerStorageWasChangedNotification"];
    self.feedResourceServiceFactory = [[[FeedResourceServiceFactory alloc] initWithStorageValue:newStorageValue] feedResourceServiceProtocol];
}

- (void) storageWasChangedNotificationFirst:(NSNotification *) notification {
    NSNumber* newStorageValue = [notification.userInfo objectForKey:@"MainViewControllerStorageWasChangedNotification"];
    self.dataSourceStrategyID = newStorageValue;
}

@end
