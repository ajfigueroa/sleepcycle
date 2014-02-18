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

/**
 @brief The delegate object that conforms to the SettingsViewControllerDelegate protocol to handle
 dismissal of the SettingsViewController.
 */
@property (nonatomic, weak) id <SettingsViewControllerDelegate> delegate;

@end

