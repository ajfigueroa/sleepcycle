//
//  TimeSelectionViewController.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 12/31/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationSlidingViewControllerProtocol.h"
#import "SettingsViewControllerDelegate.h"

@class FUIButton;

@interface TimeSelectionViewController : UIViewController <SettingsViewControllerDelegate>

@property (nonatomic, weak) id <ApplicationSlidingViewControllerProtocol> applicationDelegate;
@property (nonatomic, assign) AFSelectedUserMode selectedUserMode;

@property (weak, nonatomic) IBOutlet UIDatePicker *timeSelectionDatePicker;
@property (weak, nonatomic) IBOutlet FUIButton *confirmTimeButton;
@property (weak, nonatomic) IBOutlet FUIButton *sleepNowButton;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;

// Toggle the Menu Slider
- (IBAction)toggleSlider:(id)sender;

@end
