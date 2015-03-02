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
@property (nonatomic, strong) MasterViewController *masterViewController;
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

        ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithUser:[User currentUser]];
        TweetsViewController *tweetsViewController = [[TweetsViewController alloc] initForMentions:NO];
        TweetsViewController *mentionsViewController = [[TweetsViewController alloc] initForMentions:YES];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:tweetsViewController];

        NSArray *menuItems = @[
            @{@"text": @"", @"action":^(void){NSLog(@"0");}},// Empty cell at the top
            @{@"text": @"Profile", @"action":^(void){
                [self.navigationController setViewControllers:@[profileViewController] animated:YES];
                [self.masterViewController close];
            }},
            @{@"text": @"Timeline", @"action":^(void){
                [self.navigationController setViewControllers:@[tweetsViewController] animated:YES];
                [self.masterViewController close];
            }},
            @{@"text": @"Mentions", @"action":^(void){
                [self.navigationController setViewControllers:@[mentionsViewController] animated:YES];
                [self.masterViewController close];
            }},
            @{@"text": @"Sign Out", @"action":^(void){
                [User logout];
            }},
        ];

        HamburgerViewController *hamburgerViewController = [[HamburgerViewController alloc] initWithMenuItems:menuItems];

        self.masterViewController = [[MasterViewController alloc]
                                        initWithBackgroundViewController:hamburgerViewController
                                                foregroundViewController:self.navigationController
        ];
        self.window.rootViewController = self.masterViewController;
    } else {
        NSLog(@"Not logged in");
        viewController = [[LoginViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        self.window.rootViewController = navigationController;
    }

    [self.window makeKeyAndVisible];

    return YES;
}

- (void)pushViewController:(UIViewController *)viewController toNavigationController:(UINavigationController *)navigationController {
    if (navigationController.topViewController == viewController) {
        return;
    }
    @try {
        [navigationController setViewControllers:@[viewController] animated:YES];
        //[navigationController pushViewController:viewController animated:YES];
    } @catch (NSException * ex) {
        //“Pushing the same view controller instance more than once is not supported”
        //NSInvalidArgumentException
        NSLog(@"Exception: [%@]:%@",[ex  class], ex );
        NSLog(@"ex.name:'%@'", ex.name);
        NSLog(@"ex.reason:'%@'", ex.reason);
        //Full error includes class pointer address so only care if it starts with this error
        NSRange range = [ex.reason rangeOfString:@"Pushing the same view controller instance more than once is not supported"];

        if ([ex.name isEqualToString:@"NSInvalidArgumentException"] &&
            range.location != NSNotFound) {
            //view controller already exists in the stack - just pop back to it
            NSLog(@"Already exists");
            [navigationController popToViewController:viewController animated:YES];
        } else {
            NSLog(@"ERROR:UNHANDLED EXCEPTION TYPE:%@", ex);
        }
    } @finally {
        //NSLog(@"finally");
    }
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
