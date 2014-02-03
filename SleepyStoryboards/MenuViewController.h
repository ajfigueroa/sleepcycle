//
//  MenuViewController.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/7/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//
//  Mediator for interactions between the view controller

#import <UIKit/UIKit.h>
#import "SliderMenuApplicationDelegate.h"
#import "SettingsViewControllerDelegate.h"

@class JSSlidingViewController;
@class AlarmsViewController;

@interface MenuViewController : UITableViewController <SettingsViewControllerDelegate>

@property (nonatomic, weak) id <SliderMenuApplicationDelegate> applicationDelegate;
@property (nonatomic, strong) UINavigationController *mainNavigationController;
@property (nonatomic, strong) UINavigationController *settingsNavigationViewController;
@property (nonatomic, strong) UINavigationController *alarmsNavigationViewController;

// Settings Text Fields
@property (weak, nonatomic) IBOutlet UITextField *settingsTextField;
@property (weak, nonatomic) IBOutlet UITextField *bedTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *wakeTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *alarmsTextField;

// Settings Image Views
@property (weak, nonatomic) IBOutlet UIImageView *settingsImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bedTimeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *wakeUpTimeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *alarmImageView;


@end

