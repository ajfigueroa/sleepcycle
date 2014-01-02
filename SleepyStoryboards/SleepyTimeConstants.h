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
static NSString *const kAppTheme = @"AppTheme";

typedef enum {
    kBlueBeigeTheme,
    kBlackGrayTheme,
    kRedRoseTheme
} ThemeSelectionOption;

/*
 The SelectedUserMode enum is used to keep track of the buttons entered by
 the user.
 */
typedef enum {
    kSleepNowButton,
    kKnowWakeUpTimeButton,
    kKnowBedTimeButton
} SelectedUserMode;

/*
 The ColorMappingOrder
 */
typedef enum {
    kAscending,
    kDescending
} ColorMappingOrder;

// Notifications
static NSString *const AFThemeHasChangedNotification = @"AFThemeHasChangedNotification";

// Segue Identifier
static NSString *const AFCalculateBedTimeSegue = @"CalculateBedTimeSegue";
static NSString *const AFCalculateWakeTimeSegue = @"CalculateWakeTimeSegue";

#endif
