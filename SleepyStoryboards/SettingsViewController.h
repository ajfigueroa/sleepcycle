//
//  SettingsViewController.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/2/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeSelectionViewController.h"
#import "ThemeSettingsProtocol.h"

@protocol SettingsViewControllerDelegate;

@interface SettingsViewController : UITableViewController <ThemeSelectionViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *themeSelectionLabel;
@property (nonatomic, weak) IBOutlet UILabel *minutesLabel;
@property (nonatomic, weak) IBOutlet UISlider *minutesSlider;
@property (nonatomic, weak) id <SettingsViewControllerDelegate> delegate;
// Theme Settings Manager
@property (nonatomic, strong) id <ThemeSettingsProtocol> themeSettingsManager;

// Switches
@property (weak, nonatomic) IBOutlet UISwitch *showBorderSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *showPingPongSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *showTutorialSwitch;

- (IBAction)done:(id)sender;

@end

@protocol SettingsViewControllerDelegate <NSObject>

- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller;

@end
