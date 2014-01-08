//
//  MenuViewController.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/7/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "ApplicationDelegateSlidingViewControllerDelegate.h"

@class SettingsViewController;
@class JSSlidingViewController;

@interface MenuViewController : UITableViewController <SettingsViewControllerDelegate>

@property (nonatomic, strong) UINavigationController *mainNavigationController;
@property (nonatomic, strong) UINavigationController *settingsNavigationViewController;
@property (nonatomic, weak) id <UIApplicationDelegate, ApplicationDelegateSlidingViewControllerDelegate> applicationDelegate;

@end

