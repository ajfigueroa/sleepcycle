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

@interface MenuViewController : UITableViewController <SettingsViewControllerDelegate>

/**
 @brief The navigation controller that holds the TimeSelectionViewController as its root
 navigation controller.
 */
@property (nonatomic, strong) UINavigationController *mainNavigationController;


@end

