//
//  MainViewController.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 12/30/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIButton.h"
#import "SettingsViewController.h"

@interface MainViewController : UIViewController <SettingsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet FUIButton *calculateBedTimeButton;
@property (weak, nonatomic) IBOutlet FUIButton *calculateWakeTimeButton;
@property (weak, nonatomic) IBOutlet FUIButton *settingsButton;

@end
