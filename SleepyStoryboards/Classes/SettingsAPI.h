//
//  SettingsAPI.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/24/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//
//  SettingsAPI is making use of the Facade Pattern to handle all setting related
//  state changes

#import <Foundation/Foundation.h>

@interface SettingsAPI : NSObject

/**
 @brief The time to fall asleep in minutes.
 @note This is part of the SettingsAPI interface.
 */
@property (nonatomic, assign) NSInteger timeToFallAsleep;

/**
 @brief The enumeration that corresponds to the applications current theme.
 @note This is part of the SettingsAPI interface.
 */
@property (nonatomic, assign) NSInteger appTheme;

/**
 @brief The bool that controls whether or not the border around the main UIDatePicker in the TimeSelectionViewController is visibile.
 @note This is part of the SettingsAPI interface.
 */
@property (nonatomic, assign) BOOL showBorder;

/**
 @brief The bool that controls whether the UITableView in ResultsViewController has the Ping-Pong slide to
 refresh control.
 @note This is part of the SettingsAPI interface.
 */
@property (nonatomic, assign) BOOL showEasterEgg;

/**
 @brief The NSString representation of the appTheme's name. This is used for formatting to the views.
 */
@property (nonatomic, assign) NSString *appThemeName;

/**
 @brief The bool that controls whether the information alert view will be displayed at launch
 */
@property (nonatomic, assign) BOOL showInfoAtLaunch;

/**
 @brief Returns the shared Settings API object.
 @returns The shared SettingsAPI object to manage Persistency and Theme formatting.
 */
+ (instancetype)sharedSettingsAPI;

/**
 @brief The array of all the available theme names based off the AFThemeSelectionOption enumerations.
 @returns A NSArray of available theme names as strings.
 */
- (NSArray *)themeNames;

/**
 @brief Informs the SettingsAPI persistency manager to save all states.
 @note You should call this @b only when you are ready to save.
 */
- (void)saveAllSettings;

@end
