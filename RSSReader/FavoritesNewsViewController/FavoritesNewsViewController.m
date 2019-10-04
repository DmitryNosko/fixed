//
//  FavoritesNewsViewController.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/3/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "FavoritesNewsViewController.h"
#import "FavoritesNewsTableViewCell.h"
#import "DetailsViewController.h"
#import "WebViewController.h"
#import "ReachabilityStatusChecker.h"
//#import "FeedItemServiceProtocol.h"
//#import "FeedResourceServiceProtocol.h"
//#import "FeedItemServiceFactory.h"
#import "FeedItemServiceFactory.h"

//#import "FeedResourceServiceFactory.h"
#import "FeedResourceServiceFactory.h"

#import "MainViewController.h"

@interface FavoritesNewsViewController () <UITableViewDelegate, UITableViewDataSource, FavoritesNewsTableViewCellListener>
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray<FeedItem *>* feeds;

//@property (strong, nonatomic) id<FeedItemServiceProtocol> feedItemService;
@property (strong, nonatomic) FeedItemServiceFactory* feedItemServiceFactory;
//@property (strong, nonatomic) id<FeedResourceServiceProtocol> feedResourceService;
@property (strong, nonatomic) FeedResourceServiceFactory* feedResourceServiceFactory;

@property (strong, nonatomic) NSNumber* dataSourceStrategyID;
@end

static NSString* CELL_IDENTIFIER = @"Cell";
static NSString* VALIDATION_PATTERN_FOR_DESCRIPTION = @"<\/?[A-Za-z]+[^>]*>";
static NSNumber* DEFAULT_STORAGE_INDEX = 0;

@implementation FavoritesNewsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataSourceStrategyID = [NSUserDefaults.standardUserDefaults objectForKey:@"dataSourceStrategyID"];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(storageWasChangedNotificationFirst:)
                                                     name:MainViewControllerStorageWasChangedNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableViewSetUp];
    [self configureNavigationBar];
    self.feedItemServiceFactory = [[[FeedItemServiceFactory alloc] initWithStorageValue:self.dataSourceStrategyID] feedItemServiceProtocol];
    self.feedResourceServiceFactory = [[[FeedResourceServiceFactory alloc] initWithStorageValue:self.dataSourceStrategyID] feedResourceServiceProtocol];
    //self.feedItemService = [[FeedItemServiceFactory sharedFeedItemServiceFactory] feedItemServiceProtocol:self.dataSourceStrategyID];
    //self.feedResourceService = [[FeedResourceServiceFactory sharedFeedResourceServiceFactory] feedResourceServiceProtocol:self.dataSourceStrategyID];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storageWasChangedNotification:)
                                                 name:MainViewControllerStorageWasChangedNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.feeds = [self.feedItemServiceFactory favoriteFeedItems:[self.feedResourceServiceFactory feedResources]];
    //self.feeds = [self.feedItemService favoriteFeedItems:[self.feedResourceService feedResources]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.feeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FavoritesNewsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    cell.listener = self;
    cell.titleLabel.text = [self.feeds objectAtIndex:indexPath.row].itemTitle;
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([ReachabilityStatusChecker hasInternerConnection]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        WebViewController* dvc = [[WebViewController alloc] init];
        NSString* string = [self.feeds objectAtIndex:indexPath.row].link;
        NSString *stringForURL = [string substringWithRange:NSMakeRange(0, [string length]-6)];
        NSURL* url = [NSURL URLWithString:stringForURL];
        dvc.newsURL = url;
        [self.navigationController pushViewController:dvc animated:YES];
    } else {
        [self showNotInternerConnectionAlert];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        FeedItem* item = [self.feeds objectAtIndex:indexPath.row];
        item.isFavorite = NO;
        [self.feedItemServiceFactory updateFeedItem:item];
        //[self.feedItemService updateFeedItem:item];
        [self.feeds removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        [self.tableView reloadData];
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

#pragma mark - FavoritesNewsTableViewCellListener

- (void)didTapOnInfoButton:(FavoritesNewsTableViewCell *)infoButton {
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:infoButton];
    FeedItem* item = [self.feeds objectAtIndex:indexPath.row];
    
    DetailsViewController* dvc = [[DetailsViewController alloc] init];
    
    if ([ReachabilityStatusChecker hasInternerConnection]) {
        dvc.itemTitleString = item.itemTitle;
        dvc.itemDateString = [self dateToString:item.pubDate];;
        dvc.itemURLString = item.imageURL;
        dvc.itemDescriptionString = [self correctDescription:item.itemDescription];
        
        [self.navigationController pushViewController:dvc animated:YES];
    } else {
        dvc.itemTitleString = item.itemTitle;
        dvc.itemDescriptionString = [self correctDescription:item.itemDescription];
        [self.navigationController pushViewController:dvc animated:YES];
    }
    
}

- (NSString*) correctDescription:(NSString *) string {
    NSRegularExpression* regularExpression = [NSRegularExpression regularExpressionWithPattern:VALIDATION_PATTERN_FOR_DESCRIPTION
                                                                                       options:NSRegularExpressionCaseInsensitive
                                                                                         error:nil];
    string = [regularExpression stringByReplacingMatchesInString:string
                                                         options:0
                                                           range:NSMakeRange(0, [string length])
                                                    withTemplate:@""];
    return string;
}

#pragma mark - ViewControllerSetUp

- (void) configureNavigationBar {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"Favorites news";
}

- (void) tableViewSetUp {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView registerClass:[FavoritesNewsTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
                                              [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
                                              [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                              [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
                                              ]];
}

#pragma mark - NSNotification

- (void) storageWasChangedNotification:(NSNotification *) notification {
    NSNumber* newStorageValue = [notification.userInfo objectForKey:@"MainViewControllerStorageWasChangedNotification"];
    self.feedItemServiceFactory = [[[FeedItemServiceFactory alloc] initWithStorageValue:newStorageValue] feedItemServiceProtocol];
    self.feedResourceServiceFactory = [[[FeedResourceServiceFactory alloc] initWithStorageValue:newStorageValue] feedResourceServiceProtocol];
    //self.feedItemService = [[FeedItemServiceFactory sharedFeedItemServiceFactory] feedItemServiceProtocol:newStorageValue];
    //self.feedResourceService = [[FeedResourceServiceFactory sharedFeedResourceServiceFactory] feedResourceServiceProtocol:newStorageValue];
}

- (void) storageWasChangedNotificationFirst:(NSNotification *) notification {
    NSNumber* newStorageValue = [notification.userInfo objectForKey:@"MainViewControllerStorageWasChangedNotification"];
    self.dataSourceStrategyID = newStorageValue;
}

- (void) showNotInternerConnectionAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"Check your internet connection"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSString *) dateToString:(NSDate *) date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
    return [dateFormatter stringFromDate:date];
}

@end
