//
//  AppDelegate.m
//  RSSReader
//
//  Created by Dzmitry Noska on 8/26/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "Reachability.h"
#import "ContainerViewController.h"
#import "FeedItem.h"
#import "FavoritesNewsViewController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    ContainerViewController* vc = [[ContainerViewController alloc] init];
    vc.title = @"RSS Reader";
    FavoritesNewsViewController* fnvc = [[FavoritesNewsViewController alloc] init];
    fnvc.title = @"Favorites";
    UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:fnvc];
    UITabBarController* tbc = [[UITabBarController alloc] init];
    tbc.tabBar.barTintColor = [UIColor darkGrayColor];
    
    tbc.viewControllers = @[vc, nvc];
    
    [self.window setRootViewController:tbc];
    [self.window makeKeyAndVisible];
    
//    NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSError *error = nil;
//    for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:&error]) {
//        [[NSFileManager defaultManager] removeItemAtPath:[folderPath stringByAppendingPathComponent:file] error:&error];
//    }
    
    return YES;
}


@end
