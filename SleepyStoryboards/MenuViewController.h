//
//  MenuViewController.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/7/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//
//  Mediator for interactions between the view controller

#import <UIKit/UIKit.h>
#import "SettingsViewControllerDelegate.h"

@class JSSlidingViewController;
@class AlarmsViewController;

@interface MenuViewController : UITableViewController <SettingsViewControllerDelegate>

/**
 @brief The navigation controller that holds the TimeSelectionViewController as its root
 navigation controller.
 */
@property (nonatomic, strong) UINavigationController *mainNavigationController;

/**
 @brief The navigation controller that holds the SettingsViewController as its root navigation
 controller.
 */
@property (nonatomic, strong) UINavigationController *settingsNavigationViewController;

/**
 @brief The navigation controller that holds the AlarmsViewController as its root navigation
 controller
 */
@property (nonatomic, strong) UINavigationController *alarmsNavigationViewController;

// The Settings table static cell text fields
@property (weak, nonatomic) IBOutlet UITextField *settingsTextField;
@property (weak, nonatomic) IBOutlet UITextField *bedTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *wakeTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *alarmsTextField;

// The Settings table static cell image views
@property (weak, nonatomic) IBOutlet UIImageView *settingsImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bedTimeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *wakeUpTimeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *alarmImageView;


@end

