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
    AFThemeSelectionOptionBlueBeigeTheme, /**< The Blue and Beige color scheme, referred to as Default */
    AFThemeSelectionOptionBlackGrayTheme, /**< The Black and Gray color scheme, referrred to as Dark */
    AFThemeSelectionOptionRedRoseTheme /**< The Red and Rose color scheme, referred to as Red Rose*/
};

/*
 The SelectedUserMode enum is used to keep track of the buttons entered by
 the user.
 */
typedef NS_ENUM(NSInteger, AFSelectedUserMode)
{
    AFSelectedUserModeCalculateBedTime,
    AFSelectedUserModeCalculateWakeTime,
    AFSelectedUserModeCalculateBedTimeWithAlarmTime
};

// Notifications
static NSString *const AFThemeHasChangedNotification = @"AFThemeHasChangedNotification";
static NSString *const AFSelectedCalculateBedTimeNotification = @"AFSelectedCalculateBedTimeNotification";
static NSString *const AFSelectedCalculateWakeTimeNotification = @"AFSelectedCalculateWakeTimeNotification";
static NSString *const AFColorMappingResetNotification = @"AFColorMappingResetNotification";
static NSString *const AFAlarmHasPostedNotification = @"AFAlarmHasPostedNotification";
static NSString *const AFReminderHasPostedNotification = @"AFReminderHasPostedNotification";

// NSNotification User Info Keys
static NSString *const AFAlarmReminderNotificationSuccessKey = @"AFAlarmReminderNotificationSuccessKey";
static NSString *const AFScheduledTimeKey = @"AFScheduledTimeKey";

// Segue Identifier
static NSString *const AFCalculateBedTimeSegue = @"CalculateBedTimeSegue";
static NSString *const AFCalculateWakeTimeSegue = @"CalculateWakeTimeSegue";
static NSString *const AFSettingsSegue = @"SettingsSegue";
static NSString *const AFThemeSelectionSegue = @"ThemeSelectionSegue";
static NSString *const AFConfirmTimeButtonSegue = @"ConfirmTimeButtonSegue";
static NSString *const AFSleepNowButtonSegue = @"SleepNowButtonSegue";
static NSString *const AFAlarmClockSegue = @"AlarmClockSegue";
static NSString *const AFAboutSelectionSegue = @"AboutSelectionSegue";
static NSString *const AFFeedbackSelectionSegue = @"FeedbackSelectionSegue";
static NSString *const AFAttributionSelectionSegue = @"AttributionSelectionSegue";

// Theme count for ThemeSelectionController
static NSInteger const AFAvailableThemesCount = 3;

// Manage important sections and rows of the STATIC table view cell
typedef NS_ENUM(NSInteger, AFSectionTitles)
{
    AFSectionTitleAppearance
};

typedef NS_ENUM(NSInteger, AFAppearanceSetting)
{
    AFAppearanceSettingShowBorder = 1,
    AFAppearanceSettingShowEasterEgg
};

typedef NS_ENUM(NSInteger, AFSettingsTableOption)
{
    AFSettingsTableOptionSettings = 1,
    AFSettingsTableOptionBedTime = 3,
    AFSettingsTableOptionWakeTime,
    AFSettingsTableOptionAlarm = 6
};

#endif
