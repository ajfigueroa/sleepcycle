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

typedef enum {
    AFBlueBeigeTheme,
    AFBlackGrayTheme,
    AFRedRoseTheme
} AFThemeSelectionOption;

/*
 The SelectedUserMode enum is used to keep track of the buttons entered by
 the user.
 */
typedef enum {
    AFSleepNowButton,
    AFKnowWakeUpTimeButton,
    AFKnowBedTimeButton
} AFSelectedUserMode;

/*
 The ColorMappingOrder
 */
typedef enum {
    AFColorMappingAscending,
    AFColorMappingDescending
} AFColorMappingOrder;

// Notifications
static NSString *const AFThemeHasChangedNotification = @"AFThemeHasChangedNotification";
static NSString *const AFSelectedCalculateBedTimeNotification = @"AFSelectedCalculateBedTimeNotification";
static NSString *const AFSelectedCalculateWakeTimeNotification = @"AFSelectedCalculateWakeTimeNotification";

// Segue Identifier
static NSString *const AFCalculateBedTimeSegue = @"CalculateBedTimeSegue";
static NSString *const AFCalculateWakeTimeSegue = @"CalculateWakeTimeSegue";
static NSString *const AFSettingsSegue = @"SettingsSegue";

#endif
