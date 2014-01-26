//
//  SettingsViewController.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/2/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeSelectionViewController.h"
#import "SettingsViewControllerDelegate.h"

@interface SettingsViewController : UITableViewController <ThemeSelectionViewControllerDelegate>

@property (nonatomic, weak) id <SettingsViewControllerDelegate> delegate;
@property (nonatomic, weak) IBOutlet UILabel *themeSelectionLabel;
@property (nonatomic, weak) IBOutlet UILabel *minutesLabel;
@property (nonatomic, weak) IBOutlet UISlider *minutesSlider;

// UISwitch Outlets
@property (weak, nonatomic) IBOutlet UISwitch *showBorderSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *showPingPongSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *showTutorialSwitch;

// Action for 'Done' BarButtonItem
- (IBAction)done:(id)sender;

@end

