//
//  AppDelegate.m
//  Twitter
//
//  Created by Florian Jourda on 2/21/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "Tweet.h"
#import "MasterViewController.h"
#import "TweetsViewController.h"
#import "ProfileViewController.h"
#import "HamburgerViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout) name:UserDidLogoutNotification object:nil];

    User * user = [User currentUser];

    UIViewController *viewController;
    if (user != nil) {
        NSLog(@"Welcome back %@", user.name);

//        HamburgerViewController *hamburgerViewController = [[HamburgerViewController alloc] init];
//        UINavigationController *timelineView = [[UINavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] init]];
//        UINavigationController *profileView = [[UINavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] init]];
//        //messagesView.messagesMode = YES;
//        UINavigationController *messagesView = [[UINavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] init]];
//        MasterViewController *viewController = [[MasterViewController alloc] initWithTimelineViewController:timelineView
//                                                                                      profileViewController:profileView
//                                                                                       tweetsViewController:messagesView
//                                                                                    hamburgerViewController:hamburgerViewController];
        NSArray *menuItems = @[
            @{@"text": @"", @"action":^(void){NSLog(@"0");}},  // row for spacing
            @{@"text": @"Profile", @"action":^(void){NSLog(@"1");}},
            @{@"text": @"Timeline", @"action":^(void){NSLog(@"2");}},
            @{@"text": @"Mentions", @"action":^(void){NSLog(@"3");}},
            @{@"text": @"Log Out", @"action":^(void){NSLog(@"4");}},
        ];

        HamburgerViewController *hamburgerViewController = [[HamburgerViewController alloc] initWithMenuItems:menuItems];

        ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithUser:[User currentUser]];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
        MasterViewController *viewController = [[MasterViewController alloc]
                                                initWithBackgroundViewController:hamburgerViewController
                                                foregroundViewController:navigationController
        ];
        self.window.rootViewController = viewController;
    } else {
        NSLog(@"Not logged in");
        viewController = [[LoginViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        self.window.rootViewController = navigationController;
    }

    [self.window makeKeyAndVisible];

    return YES;
}

- (void)userDidLogout {
    self.window.rootViewController = [[LoginViewController alloc] init];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[TwitterClient sharedInstance] openURL:url];
    return YES;
}

@end
