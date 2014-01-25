//
//  SettingsViewControllerDelegate.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/25/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SettingsViewController;

@protocol SettingsViewControllerDelegate <NSObject>

- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller;

@end
