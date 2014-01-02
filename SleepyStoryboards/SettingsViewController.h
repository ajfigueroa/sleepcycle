//
//  SettingsViewController.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/2/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeSelectionViewController.h"

@interface SettingsViewController : UITableViewController <ThemeSelectionViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *themeSelectionLabel;

@end
