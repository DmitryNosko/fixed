//
//  MainViewController.m
//  RSSReader
//
//  Created by Dzmitry Noska on 8/26/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "MainViewController.h"
#import "WebViewController.h"
#import "MainTableViewCell.h"
#import "DetailsViewController.h"
#import "FeedItem.h"
#import "RSSParser.h"
#import "MenuViewController.h"
#import "Reachability+ReachabilityCategory.h"
#import "FeedItemServiceFactory.h"
#import "FeedResourceServiceFactory.h"
#import "DataSourceMigratorFactory.h"
#import "DataSourceMigratorProtocol.h"
#import "SQLFeedResourceService.h"
#import "SQLFeedItemService.h"
#import "NSDate+NSDateRSSReaderCategory.h"
#import "UIAlertController+UIAlertControllerCategory.h"
#import "InternetConnectionConstants.h"
#import "MainViewControllerConstants.h"
#import "UITableView+UITableViewCategory.h"
#import "UILabel+UILabelCategory.h"
#import "UISegmentedControl+UISegmentedControlCategory.h"
#import "UIVisualEffectView+UIVisualEffectViewCategory.h"
#import "UIBarButtonItem+UIBarButtonItemCategory.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, MainTableViewCellListener, WebViewControllerListener>
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray<FeedItem *>* displayedFeeds;
@property (strong, nonatomic) NSMutableArray<FeedItem *>* parsedFeeds;
@property (strong, nonatomic) UIVisualEffectView* settingsView;
@property (strong, nonatomic) RSSParser* rssParser;
@property (strong, nonatomic) NSMutableDictionary<NSURL*, FeedResource*>* feedResourceByURL;
@property (strong, nonatomic) NSMutableArray<NSString *>* readingCompliteItemsLinks;
@property (strong, nonatomic) NSMutableArray<NSString *>* readingInProgressItemsLinks;
@property (strong, nonatomic) NSMutableArray<NSString *>* favoriteItemsLinks;
@property (strong, nonatomic) NSIndexPath* selectedFeedItemIndexPath;
@property (assign, nonatomic) BOOL isSelectedEditButton;
@property (strong, nonatomic) UISegmentedControl* switchDateSegmentController;
@property (strong, nonatomic) UISegmentedControl* switchStorageSegmentController;
@property (strong, nonatomic) FeedItemServiceFactory* feedItemServiceFactory;
@property (strong, nonatomic) FeedResourceServiceFactory* feedResourceServiceFactory;
@end

NSString* const MainViewControllerStorageWasChangedNotification = @"MainViewControllerStorageWasChangedNotification";

@implementation MainViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self feedResourceWasChosenHandlerMethod];
        [self feedResourceWasAddedHandlerMethod];
        [self fetchButtonWasPressefHandlerMethod];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureNavigationBar];
    [self tableViewSetUp];
    [self setUpSettingsView];
    [self timeRangeSetUp];
    self.displayedFeeds = [[NSMutableArray alloc] init];
    self.parsedFeeds = [[NSMutableArray alloc] init];
    
    NSNumber* storageStrategyID = @(self.switchStorageSegmentController.selectedSegmentIndex);
    
    self.feedItemServiceFactory = [[[FeedItemServiceFactory alloc] initWithStorageValue:storageStrategyID] feedItemServiceProtocol];
    self.feedResourceServiceFactory = [[[FeedResourceServiceFactory alloc] initWithStorageValue:storageStrategyID] feedResourceServiceProtocol];
    
    FeedResource* defautlResource = [self.feedResourceServiceFactory resourceByURL:[NSURL URLWithString:DEFAULT_URL_TO_PARSE]];
    
    if (!defautlResource) {
        defautlResource = [self.feedResourceServiceFactory  addFeedResource:
                           [[FeedResource alloc] initWithID:[NSUUID UUID] name:DEFAULT_RESOURCE_NAME url:[NSURL URLWithString:DEFAULT_URL_TO_PARSE]]
                           ];
    }
    
    self.feedResourceByURL = [[NSMutableDictionary alloc] initWithObjectsAndKeys:defautlResource, defautlResource.url, nil];
    
    self.readingCompliteItemsLinks = [self.feedItemServiceFactory readingCompliteFeedItemLinks:[[NSMutableArray alloc] initWithArray:[self.feedResourceByURL allValues]]];
    self.readingInProgressItemsLinks = [self.feedItemServiceFactory readingInProgressFeedItemLinks:[[NSMutableArray alloc] initWithArray:[self.feedResourceByURL allValues]]];
    
    self.rssParser = [[RSSParser alloc] init];
    
    __weak MainViewController* weakSelf = self;
    self.rssParser.feedItemDownloadedHandler = ^(FeedItem *item) {
        NSThread* thread = [[NSThread alloc] initWithBlock:^{
            [weakSelf addParsedFeedItemToFeeds:item];
            [weakSelf performSelectorOnMainThread:@selector(reloadDataHandler) withObject:item waitUntilDone:NO];
        }];
        [thread start];
    };
    
    if ([Reachability hasInternerConnection]) {
        [self.rssParser rssParseWithURL:[NSURL URLWithString:DEFAULT_URL_TO_PARSE]];
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:INTERNET_CONNECTION_ALERT_TITLE message:INTERNET_CONNECTION_MESSAGE firstTextFieldTitle:nil secondTextFieldTitle:nil hasCloseButton:NO andBlock:nil];
        [self presentViewController:alert animated:YES completion:nil];
        self.displayedFeeds = [self.feedItemServiceFactory feedItemsForResource:defautlResource];
    }
    
    [self feedItemsWasLoadedHandlerMethod];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.favoriteItemsLinks = [self.feedItemServiceFactory favoriteFeedItemLinks:[[NSMutableArray alloc] initWithArray:[self.feedResourceByURL allValues]]];
    [self.tableView reloadData];
}

- (void) filterNewsByDate {
    
    self.isSelectedEditButton = !self.isSelectedEditButton;
    
    if (self.isSelectedEditButton) {
        self.settingsView.hidden = NO;
        self.tableView.scrollEnabled = NO;
        self.tableView.userInteractionEnabled = NO;
    } else {
        self.settingsView.hidden = YES;
        self.tableView.scrollEnabled = YES;
        self.tableView.userInteractionEnabled = YES;
        NSUInteger timeRange = [[NSUserDefaults standardUserDefaults] integerForKey:TIME_RANGE_KEY];
        
        [self.displayedFeeds removeAllObjects];
        
        NSMutableArray<FeedItem *>* itemsToSort = [self.feedItemServiceFactory feedItemsForResources:[[NSMutableArray alloc] initWithArray:[self.feedResourceByURL allValues]]];
        
        for (FeedItem* item in itemsToSort) {
            if (ABS([item.pubDate timeIntervalSinceNow]) < 60 * 60 * 24 * timeRange) {
                [self.displayedFeeds addObject:item];
            }
        }
        [self.tableView reloadData];
    }
}

- (void) timeRangeChanged {
    switch ([self.switchDateSegmentController selectedSegmentIndex]) {
        case 0:
            [[NSUserDefaults standardUserDefaults] setInteger:91 forKey:TIME_RANGE_KEY];
            break;
        case 1:
            [[NSUserDefaults standardUserDefaults] setInteger:30 forKey:TIME_RANGE_KEY];
            break;
        case 2:
            [[NSUserDefaults standardUserDefaults] setInteger:7 forKey:TIME_RANGE_KEY];
            break;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.displayedFeeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    cell.listener = self;
    cell.titleLabel.text = [self.displayedFeeds objectAtIndex:indexPath.row].itemTitle;
    
    FeedItem* item = [self.displayedFeeds objectAtIndex:indexPath.row];
    
    if (item.isReadingInProgress) {
        cell.stateLabel.text = READING_NEWS_STATUS;
    }
    
    if ([self.favoriteItemsLinks containsObject:item.link]) {
        [cell.favoritesButton setImage:[UIImage imageNamed:FULL_STAR_BUTTON_IMAGE] forState:UIControlStateNormal];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([Reachability hasInternerConnection]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        FeedItem* item = [self.displayedFeeds objectAtIndex:indexPath.row];
        item.isReadingInProgress = YES;
        item.resource = [self.feedResourceByURL objectForKey:item.resourceURL];
        
        NSThread* thread = [[NSThread alloc] initWithBlock:^{
            [self.feedItemServiceFactory updateFeedItem:item];
            [self.readingInProgressItemsLinks addObject:item.link];
        }];
        [thread start];
        
        WebViewController* dvc = [[WebViewController alloc] init];
        dvc.listener = self;
        self.selectedFeedItemIndexPath = indexPath;
        NSString* string = [self.displayedFeeds objectAtIndex:indexPath.row].link;
        NSString *stringForURL = [string substringWithRange:NSMakeRange(0, [string length]-6)];
        NSURL* url = [NSURL URLWithString:stringForURL];
        dvc.newsURL = url;
        [self.navigationController pushViewController:dvc animated:YES];
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:INTERNET_CONNECTION_ALERT_TITLE message:INTERNET_CONNECTION_MESSAGE firstTextFieldTitle:nil secondTextFieldTitle:nil hasCloseButton:NO andBlock:nil];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

#pragma mark - MainTableViewCellListener

- (void)didTapOnInfoButton:(MainTableViewCell *)infoButton {
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:infoButton];
    FeedItem* item = [self.displayedFeeds objectAtIndex:indexPath.row];
    
    DetailsViewController* dvc = [[DetailsViewController alloc] init];
    
    if ([Reachability hasInternerConnection]) {
        dvc.hasInternetConnection = YES;
        dvc.itemTitleString = item.itemTitle;
        dvc.itemDateString = [item.pubDate toString];
        dvc.itemURLString = item.imageURL;
        dvc.itemDescriptionString = item.itemDescription;
        [self.navigationController pushViewController:dvc animated:YES];
    } else {
        dvc.hasInternetConnection = NO;
        dvc.itemTitleString = item.itemTitle;
        dvc.itemDescriptionString = item.itemDescription;
        [self.navigationController pushViewController:dvc animated:YES];
    }
}

- (void) didTapOnFavoritesButton:(MainTableViewCell *) favoritesButton {
    NSIndexPath* indexPath = [self.tableView indexPathForCell:favoritesButton];
    FeedItem* item = [self.displayedFeeds objectAtIndex:indexPath.row];
    
    if (item.isFavorite) {
        item.isFavorite = NO;
        [self.favoriteItemsLinks removeObject:item.link];
        NSThread* thread = [[NSThread alloc] initWithBlock:^{
            [self.feedItemServiceFactory updateFeedItem:item];
        }];
        [thread start];
    } else {
        item.isFavorite = YES;
        [self.favoriteItemsLinks addObject:item.link];
        NSThread* thread = [[NSThread alloc] initWithBlock:^{
            [self.feedItemServiceFactory updateFeedItem:item];
        }];
        [thread start];
    }
    [self.tableView reloadData];
}

#pragma mark - MainTableViewCellListener

- (void) didTapOnDoneButton:(UIBarButtonItem *)doneButton {
    FeedItem* item = [self.displayedFeeds objectAtIndex:self.selectedFeedItemIndexPath.row];
    item.isReadingComplite = YES;
    [self.readingCompliteItemsLinks addObject:item.link];
    [self.feedItemServiceFactory updateFeedItem:item];
    [self.displayedFeeds removeObjectAtIndex:self.selectedFeedItemIndexPath.row];
    [self.parsedFeeds removeObjectAtIndex:self.selectedFeedItemIndexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[self.selectedFeedItemIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
}

#pragma mark - ViewControllerSetUp

- (void) tableViewSetUp {
    self.tableView = [UITableView tableVeiwWithFrame:CGRectZero style:UITableViewStylePlain cellClass:[MainTableViewCell class] cellIdentifier:CELL_IDENTIFIER parentView:self.view delegateAndDataSource:self];
    [NSLayoutConstraint activateConstraints:@[
                                              [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
                                              [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
                                              [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                              [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
                                              ]];
}
- (void) setUpSettingsView {

    self.settingsView = [UIVisualEffectView viewWithBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark] parentView:self.view cornerRadius:35];
    
    self.switchDateSegmentController = [UISegmentedControl controlWithItems:@[THREE_MONTH_TIME_RANGE, ONE_MONTH_TIME_RANGE, ONE_WEEK_TIME_RANGE] parentView:self.settingsView.contentView target:self action:@selector(timeRangeChanged)];
    
    UILabel* chouseDateLabel = [UILabel labelWithText:CHOUSE_NEWS_TIME_INTERVAL andFontSize:14 parentView:self.settingsView.contentView textColor:[UIColor whiteColor] textAligment:NSTextAlignmentCenter];
    
    UILabel* chouseLocalDBLabel = [UILabel labelWithText:CHOUSE_STORAGE_FOR_NEWS andFontSize:14 parentView:self.settingsView.contentView textColor:[UIColor whiteColor] textAligment:NSTextAlignmentCenter];
    
    self.switchStorageSegmentController = [UISegmentedControl controlWithItems:@[FILE_STORAGE_NAME, SQL_STORAGE_NAME, CORE_DATA_STORAGE_NAME] parentView:self.settingsView.contentView target:self action:@selector(changeStorage:)];
    
    if ([NSUserDefaults.standardUserDefaults objectForKey:DATA_SOURCE_STRATEGY_ID]) {
        [self.switchStorageSegmentController setSelectedSegmentIndex:[[NSUserDefaults.standardUserDefaults objectForKey:DATA_SOURCE_STRATEGY_ID] integerValue]];
    } else {
        [self.switchStorageSegmentController setSelectedSegmentIndex:0];
        [NSUserDefaults.standardUserDefaults setObject:DEFAULT_STORAGE_INDEX forKey:DATA_SOURCE_STRATEGY_ID];
        [NSUserDefaults.standardUserDefaults synchronize];
    }
    
    self.settingsView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.settingsView.centerXAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerXAnchor],
                                              [self.settingsView.centerYAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerYAnchor],
                                              [self.settingsView.heightAnchor constraintEqualToConstant:300],
                                              [self.settingsView.widthAnchor constraintEqualToConstant:250]
                                              ]];
    
    chouseDateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [chouseDateLabel.centerXAnchor constraintEqualToAnchor:self.settingsView.contentView.centerXAnchor],
                                              [chouseDateLabel.topAnchor constraintEqualToAnchor:self.settingsView.contentView.topAnchor constant:30],
                                              [chouseDateLabel.heightAnchor constraintEqualToConstant:20],
                                              [chouseDateLabel.trailingAnchor constraintEqualToAnchor:self.settingsView.contentView.trailingAnchor constant:-10],
                                              [chouseDateLabel.leadingAnchor constraintEqualToAnchor:self.settingsView.contentView.leadingAnchor constant:10]
                                              ]];
    
    self.switchDateSegmentController.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.switchDateSegmentController.centerXAnchor constraintEqualToAnchor:self.settingsView.contentView.centerXAnchor],
                                              [self.switchDateSegmentController.topAnchor constraintEqualToAnchor:chouseDateLabel.bottomAnchor constant:10],
                                              [self.switchDateSegmentController.heightAnchor constraintEqualToConstant:30],
                                              [self.switchDateSegmentController.trailingAnchor constraintEqualToAnchor:self.settingsView.contentView.trailingAnchor constant:-10],
                                              [self.switchDateSegmentController.leadingAnchor constraintEqualToAnchor:self.settingsView.contentView.leadingAnchor constant:10]
                                              ]];
    
    chouseLocalDBLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [chouseLocalDBLabel.centerXAnchor constraintEqualToAnchor:self.settingsView.contentView.centerXAnchor],
                                              [chouseLocalDBLabel.topAnchor constraintEqualToAnchor:self.switchDateSegmentController.bottomAnchor constant:50],
                                              [chouseLocalDBLabel.heightAnchor constraintEqualToConstant:20],
                                              [chouseLocalDBLabel.trailingAnchor constraintEqualToAnchor:self.settingsView.contentView.trailingAnchor constant:-10],
                                              [chouseLocalDBLabel.leadingAnchor constraintEqualToAnchor:self.settingsView.contentView.leadingAnchor constant:10]
                                              ]];
    
    self.switchStorageSegmentController.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.switchStorageSegmentController.centerXAnchor constraintEqualToAnchor:self.settingsView.contentView.centerXAnchor],
                                              [self.switchStorageSegmentController.topAnchor constraintEqualToAnchor:chouseLocalDBLabel.bottomAnchor constant:10],
                                              [self.switchStorageSegmentController.heightAnchor constraintEqualToConstant:30],
                                              [self.switchStorageSegmentController.trailingAnchor constraintEqualToAnchor:self.settingsView.contentView.trailingAnchor constant:-10],
                                              [self.switchStorageSegmentController.leadingAnchor constraintEqualToAnchor:self.settingsView.contentView.leadingAnchor constant:10]
                                              ]];
}


- (void) timeRangeSetUp {
    NSUInteger timeRange = [[NSUserDefaults standardUserDefaults] integerForKey:TIME_RANGE_KEY];
    if (!timeRange) {
        [[NSUserDefaults standardUserDefaults] setInteger:30 forKey:TIME_RANGE_KEY];
        timeRange = 30;
    }
    
    switch (timeRange) {
        case 7:
            [self.switchDateSegmentController setSelectedSegmentIndex:2];
            break;
            
        case 91:
            [self.switchDateSegmentController setSelectedSegmentIndex:0];
            break;
            
        default:
            [self.switchDateSegmentController setSelectedSegmentIndex:1];
            break;
    }
}

- (void) changeStorage:(UISegmentedControl *) sender {
    NSNumber* dataSourceStrategyID = @(sender.selectedSegmentIndex);
    [[[[DataSourceMigratorFactory alloc] initWithResourceService:self.feedResourceServiceFactory itemService:self.feedItemServiceFactory] dataSourceMigratorProtocol:dataSourceStrategyID] migrateData];
    self.feedItemServiceFactory = [[[FeedItemServiceFactory alloc] initWithStorageValue:dataSourceStrategyID] feedItemServiceProtocol];
    self.feedResourceServiceFactory = [[[FeedResourceServiceFactory alloc] initWithStorageValue:dataSourceStrategyID] feedResourceServiceProtocol];
    
    NSDictionary* dictionary = [NSDictionary dictionaryWithObject:dataSourceStrategyID forKey:@"MainViewControllerStorageWasChangedNotification"];
    [[NSNotificationCenter defaultCenter] postNotificationName:MainViewControllerStorageWasChangedNotification
                                                        object:nil
                                                      userInfo:dictionary];
    
    [NSUserDefaults.standardUserDefaults setObject:dataSourceStrategyID forKey:DATA_SOURCE_STRATEGY_ID];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void) configureNavigationBar {
    self.navigationItem.title = MAIN_VIEW_CONTROLLER_TITLE;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"Resources" image:nil block:^{
        [self.delegate handleMenuToggle];
    }];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:nil image:[UIImage imageNamed:SETTINGS_BUTTON_IMAGE] block:^{
        [self filterNewsByDate];
    }];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

#pragma mark - Shake gesture

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    [self.displayedFeeds removeAllObjects];
    
    __weak MainViewController* weakSelf = self;
    self.rssParser.feedItemDownloadedHandler = ^(FeedItem *item) {
        NSThread* thread = [[NSThread alloc] initWithBlock:^{
            [weakSelf addParsedFeedItemToFeeds:item];
            [weakSelf performSelectorOnMainThread:@selector(reloadDataHandler) withObject:item waitUntilDone:NO];
        }];
        [thread start];
    };
    
    for (NSURL* url in [self.feedResourceByURL allKeys]) {
        [self.rssParser rssParseWithURL:url];
    }
    
}

#pragma mark - MenuViewControllerHandlers

- (void) feedResourceWasAddedHandlerMethod {
    __weak MainViewController* weakSelf = self;
    
    self.feedResourceWasAddedHandler = ^(FeedResource *resource) {
        [weakSelf.displayedFeeds removeAllObjects];
        [weakSelf.parsedFeeds removeAllObjects];
        
        [weakSelf.feedResourceByURL setObject:resource forKey:resource.url];
        
        weakSelf.rssParser.feedItemDownloadedHandler = ^(FeedItem *item) {
            NSThread* thread = [[NSThread alloc] initWithBlock:^{
                [weakSelf addParsedFeedItemToFeeds:item];
                [weakSelf performSelectorOnMainThread:@selector(reloadDataHandler) withObject:item waitUntilDone:NO];
            }];
            [thread start];
        };
        
        [weakSelf.rssParser rssParseWithURL:resource.url];
    };
}



- (void) feedResourceWasChosenHandlerMethod {
    __weak MainViewController* weakSelf = self;
    self.feedResourceWasChosenHandler = ^(FeedResource *resource) {
        //NSMutableArray<FeedItem*>* items = [weakSelf.feedItemServiceFactory feedItemsForResource:resource];
        NSMutableArray<FeedItem*>* items = [weakSelf.feedItemServiceFactory feedItemsForResources:[[NSMutableArray alloc] initWithObjects:resource, nil]];
        weakSelf.displayedFeeds = items;
        [weakSelf.tableView reloadData];
    };
}

- (void) addParsedFeedItemToFeeds:(FeedItem* ) item {
    if (item) {
        item.identifier = [NSUUID UUID];
        item.resource = [self.feedResourceByURL objectForKey:item.resourceURL];
        item.isReadingInProgress = [self.readingInProgressItemsLinks containsObject:item.link];
        item.isFavorite = [self.favoriteItemsLinks containsObject:item.link];
        if (![self.readingCompliteItemsLinks containsObject:item.link]) {
            item.isReadingComplite = NO;
            [self.displayedFeeds addObject:item];
        } else {
            item.isReadingComplite = YES;
        }
        [self.parsedFeeds addObject:item];
    }
}

- (void) reloadDataHandler {
    [self.tableView reloadData];
}


- (void) feedItemsWasLoadedHandlerMethod {
    __weak MainViewController* weakSelf = self;
    self.rssParser.parserDidEndDocumentHandler = ^{
        [weakSelf.displayedFeeds sortUsingComparator:^NSComparisonResult(FeedItem* obj1, FeedItem* obj2) {
            return [obj2.pubDate compare:obj1.pubDate];
        }];
        [weakSelf.feedItemServiceFactory cleanSaveFeedItems:weakSelf.parsedFeeds];
        [weakSelf performSelectorOnMainThread:@selector(reloadDataHandler) withObject:nil waitUntilDone:NO];
    };
}

- (void) fetchButtonWasPressefHandlerMethod {
    __weak MainViewController* weakSelf = self;
    self.fetchButtonWasPressedHandler = ^(NSMutableArray<FeedResource *> *resource) {
        [weakSelf.displayedFeeds removeAllObjects];
        [weakSelf.parsedFeeds removeAllObjects];
        
        weakSelf.rssParser.feedItemDownloadedHandler = ^(FeedItem *item) {
            NSThread* thread = [[NSThread alloc] initWithBlock:^{
                [weakSelf addParsedFeedItemToFeeds:item];
                [weakSelf performSelectorOnMainThread:@selector(reloadDataHandler) withObject:item waitUntilDone:NO];
            }];
            [thread start];
        };
        for (FeedResource* fr in [resource copy]) {
            [weakSelf.rssParser rssParseWithURL:fr.url];
        }
    };
}

@end

