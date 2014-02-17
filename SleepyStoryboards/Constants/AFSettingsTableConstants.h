//
//  AFSettingsTableConstants.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 2/17/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#ifndef SleepyStoryboards_AFSettingsTableConstants_h
#define SleepyStoryboards_AFSettingsTableConstants_h

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
