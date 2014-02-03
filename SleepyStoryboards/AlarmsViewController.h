//
//  AlarmsViewController.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/9/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderMenuApplicationDelegate.h"
#import "SettingsViewControllerDelegate.h"

@interface AlarmsViewController : UITableViewController <SettingsViewControllerDelegate>

@property (nonatomic, weak) id <SliderMenuApplicationDelegate> applicationDelegate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

// Toggle the Menu Slider
- (IBAction)toggleSlider:(id)sender;
- (IBAction)toggleEditMode:(id)sender;

@end
