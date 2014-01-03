//
//  SettingsSelectionConstants.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/2/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#ifndef SleepyStoryboards_SettingsSelectionConstants_h
#define SleepyStoryboards_SettingsSelectionConstants_h

static NSInteger const AFAvailableThemesCount = 3;

// Manage important sections and rows of the STATIC table view cell
typedef NS_ENUM(NSInteger, AFSectionTitles)
{
    AFSectionTitleAppearance,
    AFSectionTitleBehaviour
};

typedef NS_ENUM(NSInteger, AFAppearanceSetting)
{
    AFAppearanceSettingShowBorder = 1
};

typedef NS_ENUM(NSInteger, AFBehaviourSetting)
{
    AFBehaviourSettingShowEasterEgg
};

#endif
