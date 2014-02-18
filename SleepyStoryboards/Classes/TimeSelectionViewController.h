//
//  TimeSelectionViewController.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 12/31/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewControllerDelegate.h"
#import "AFSleepCycleConstants.h"

@class FUIButton;

@interface TimeSelectionViewController : UIViewController <SettingsViewControllerDelegate>

@property (nonatomic, assign) AFSelectedUserMode selectedUserMode;

@end
