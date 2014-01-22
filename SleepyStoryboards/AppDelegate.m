//
//  AppDelegate.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 12/30/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import "AppDelegate.h"
#import "TimeSelectionViewController.h"

@implementation AppDelegate

+ (void)initialize
{
    // Get the "default defaults" filename
    NSString *defaultsFileName = [[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"];
    
    // Initialize a dictionary with the contents of the defaults
    NSDictionary *defaults = [NSDictionary dictionaryWithContentsOfFile:defaultsFileName];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];

    MenuViewController *menuViewController = (MenuViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MenuView"];
    menuViewController.applicationDelegate = self;
    
    TimeSelectionViewController *timeSelectionViewController = (TimeSelectionViewController *)menuViewController.mainNavigationController.viewControllers.firstObject;
    timeSelectionViewController.selectedUserMode = AFSelectedUserModeCalculateBedTime;
    timeSelectionViewController.applicationDelegate = self;
    
    self.slidingViewController = [[JSSlidingViewController alloc] initWithFrontViewController:menuViewController.mainNavigationController backViewController:menuViewController];
    self.slidingViewController.showsDropShadows = YES;
    self.slidingViewController.useBouncyAnimations = NO;
    
    self.window.rootViewController = self.slidingViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
