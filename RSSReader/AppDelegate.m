//
//  AppDelegate.m
//  RSSReader
//
//  Created by Dzmitry Noska on 8/26/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "ContainerViewController.h"
#import "FavoritesNewsViewController.h"

@interface AppDelegate ()
@end

static NSString* const CONTAINER_VC_TITLE = @"NEWS";
static NSString* const FAVORITES_NEWS_VC_TITLE = @"FAVORITIES";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
    [self configurateNavigationBar];

    ContainerViewController* vc = [[ContainerViewController alloc] init];
    vc.title = CONTAINER_VC_TITLE;
    FavoritesNewsViewController* fnvc = [[FavoritesNewsViewController alloc] init];
    fnvc.title = FAVORITES_NEWS_VC_TITLE;
    
    UITabBarController* tbc = [[UITabBarController alloc] init];
    tbc.tabBar.barTintColor = [UIColor darkGrayColor];
    tbc.viewControllers = @[vc, [[UINavigationController alloc] initWithRootViewController:fnvc]];
    
    [self.window setRootViewController:tbc];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void) configurateNavigationBar {
    [[UINavigationBar appearance] setBarTintColor:[UIColor darkGrayColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setTranslucent:NO];
}


@end
