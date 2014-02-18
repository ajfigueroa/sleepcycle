//
//  SettingsViewControllerDelegate.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/25/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SettingsViewController;

/**
 @brief The SettingsViewController protocol defines methods that  view controller should adhere to to 
 receive updates on the ending of the modal presentation of the SettingsViewController object. 
 The delegate is responsible for handling dismissal of the view controller.
 */
@protocol SettingsViewControllerDelegate <NSObject>

/**
 @brief The message sent to the delegate that the tasks on the SettingViewController have completed.
 @param controller The SettingsViewController that is sending the message to the receiver.
 */
- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller;

@end
