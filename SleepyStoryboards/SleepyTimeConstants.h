//
//  SleepyTimeConstants.h
//  SleepyTimeUpdate
//
//  Created by Alexander Figueroa on 11/20/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#ifndef SleepyTimeUpdate_SleepyTimeConstants_h
#define SleepyTimeUpdate_SleepyTimeConstants_h

// Key for accessing themes across view controllers (NSUserDefaults key)
static NSString *const AFAppTheme = @"AppTheme";
static NSString *const AFShowEasterEgg = @"ShowEasterEgg";
static NSString *const AFShowDatePickerBorder = @"ShowBorder";
static NSString *const AFTimeToFallAsleepInMinutes = @"TimeToFallAsleepInMinutes";

typedef NS_ENUM(NSInteger, AFThemeSelectionOption)
{
    AFThemeSelectionOptionBlueBeigeTheme,
    AFThemeSelectionOptionBlackGrayTheme,
    AFThemeSelectionOptionRedRoseTheme
};

/*
 The SelectedUserMode enum is used to keep track of the buttons entered by
 the user.
 */
typedef NS_ENUM(NSInteger, AFSelectedUserMode)
{
    AFSelectedUserModeCalculateBedTime,
    AFSelectedUserModeCalculateWakeTime
};

// Notifications
static NSString *const AFThemeHasChangedNotification = @"AFThemeHasChangedNotification";
static NSString *const AFSelectedCalculateBedTimeNotification = @"AFSelectedCalculateBedTimeNotification";
static NSString *const AFSelectedCalculateWakeTimeNotification = @"AFSelectedCalculateWakeTimeNotification";
static NSString *const AFColorMappingResetNotification = @"AFColorMappingResetNotification";

// Segue Identifier
static NSString *const AFCalculateBedTimeSegue = @"CalculateBedTimeSegue";
static NSString *const AFCalculateWakeTimeSegue = @"CalculateWakeTimeSegue";
static NSString *const AFSettingsSegue = @"SettingsSegue";
static NSString *const AFThemeSelectionSegue = @"ThemeSelectionSegue";
static NSString *const AFConfirmTimeButtonSegue = @"ConfirmTimeButtonSegue";
static NSString *const AFSleepNowButtonSegue = @"SleepNowButtonSegue";

#endif
