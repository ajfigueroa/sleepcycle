//
//  AFSettingsTableConstants.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 2/17/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#ifndef SleepyStoryboards_AFSettingsTableConstants_h
#define SleepyStoryboards_AFSettingsTableConstants_h

// The constants used to represent sections and rows of the static table view cell
// in SettingsViewController.
typedef NS_ENUM(NSInteger, AFSectionTitles)
{
    /** The header for the section in the Settings table that controls Appearance */
    AFSectionTitleAppearance
};

typedef NS_ENUM(NSInteger, AFAppearanceSetting)
{
    /** The header for the section in the Settings table that controls Show Border */
    AFAppearanceSettingShowBorder = 1,
    /** The header for the section in the Settings table that controls Show Easter Egg (Ping Pong) */
    AFAppearanceSettingShowEasterEgg
};

// The constants used to represent the rows on the slider menu.
typedef NS_ENUM(NSInteger, AFSettingsTableOption)
{
    /** The row in the slider menu that corresponds to the Settings section */
    AFSettingsTableOptionSettings = 1,
    /** The row in the slider menu that corresponds to the Calculate Bed Time section */
    AFSettingsTableOptionBedTime = 3,
    /** The row in the slider menu that corresponds to the Calculate Wake Time section */
    AFSettingsTableOptionWakeTime,
    /** The row in the slider menu that corresponds to the Alarms section */
    AFSettingsTableOptionAlarm = 6
};

#endif
